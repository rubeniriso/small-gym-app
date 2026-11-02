import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_app/domain/dates.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/providers.dart';

class CreateTemplateScreen extends ConsumerStatefulWidget {
  const CreateTemplateScreen({super.key});

  @override
  ConsumerState<CreateTemplateScreen> createState() =>
      _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends ConsumerState<CreateTemplateScreen> {
  final _name = TextEditingController();
  final _weights = {
    for (final exercise in Exercise.strongLifts)
      exercise: TextEditingController(),
  };
  DateTime? _anchor;
  String? _error;
  var _saving = false;

  @override
  void dispose() {
    _name.dispose();
    for (final controller in _weights.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickMonday() async {
    final now = ref.read(clockProvider)();
    final picked = await showDatePicker(
      context: context,
      helpText: 'Week 1 Monday',
      initialDate: _anchor ?? upcomingMonday(now),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      selectableDayPredicate: (day) => day.weekday == DateTime.monday,
    );
    if (picked == null) {
      return;
    }
    setState(() => _anchor = dateOnly(picked));
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Enter a name.');
      return;
    }
    final anchor = _anchor;
    if (anchor == null) {
      setState(() => _error = 'Choose a Monday.');
      return;
    }
    final weights = <Exercise, double>{};
    for (final exercise in Exercise.strongLifts) {
      final weight = tryParseKg(_weights[exercise]!.text);
      if (weight == null) {
        setState(() => _error = 'Enter a weight for every exercise.');
        return;
      }
      weights[exercise] = weight;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.mutate(
        (repository) => repository.createFromTemplate(
          name: name,
          anchorMonday: anchor,
          startWeightsKg: weights,
        ),
      );
    } on ArgumentError catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _error = error.message is String
            ? error.message as String
            : 'Could not create the routine.';
      });
      return;
    }
    if (!mounted) {
      return;
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('12-week template', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Workout A and Workout B alternate on Monday, Wednesday, and Friday for 12 weeks.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _name,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _pickMonday,
          child: Text(
            _anchor == null ? 'Choose a Monday' : formatLongDate(_anchor!),
          ),
        ),
        const SizedBox(height: 24),
        Text('Starting weights', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final exercise in Exercise.strongLifts) ...[
          TextField(
            controller: _weights[exercise],
            decoration: InputDecoration(
              labelText: exercise.label,
              suffixText: 'kg',
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
          const SizedBox(height: 12),
        ],
        if (_error != null) ...[
          Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          const SizedBox(height: 12),
        ],
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: const Text('Create routine'),
        ),
      ],
    );
  }
}
