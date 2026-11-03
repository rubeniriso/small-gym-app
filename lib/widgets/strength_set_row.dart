import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/l10n/app_strings.dart';

class StrengthSetRow extends StatelessWidget {
  const StrengthSetRow({
    super.key,
    required this.exerciseKey,
    required this.setIndex,
    required this.label,
    required this.placeholder,
    required this.done,
    required this.onEdit,
    required this.onToggle,
  });

  final String exerciseKey;
  final int setIndex;
  final String label;
  final bool placeholder;
  final bool done;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: placeholder
                ? theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : theme.textTheme.bodyLarge,
          ),
        ),
        IconButton(
          key: Key('edit-set-$exerciseKey-$setIndex'),
          tooltip: context.s.text('Edit set'),
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
        Checkbox(
          key: Key('set-$exerciseKey-$setIndex'),
          value: done,
          onChanged: (_) => onToggle(),
        ),
      ],
    );
  }
}

Future<({double weightKg, int reps})?> editStrengthSet(
  BuildContext context, {
  required double weightKg,
  required int reps,
}) {
  return showDialog<({double weightKg, int reps})>(
    context: context,
    builder: (context) => _EditSetDialog(weightKg: weightKg, reps: reps),
  );
}

class _EditSetDialog extends StatefulWidget {
  const _EditSetDialog({required this.weightKg, required this.reps});

  final double weightKg;
  final int reps;

  @override
  State<_EditSetDialog> createState() => _EditSetDialogState();
}

class _EditSetDialogState extends State<_EditSetDialog> {
  late final TextEditingController _weight;
  late final TextEditingController _reps;
  String? _error;

  @override
  void initState() {
    super.initState();
    _weight = TextEditingController(text: formatKg(widget.weightKg));
    _reps = TextEditingController(text: '${widget.reps}');
  }

  @override
  void dispose() {
    _weight.dispose();
    _reps.dispose();
    super.dispose();
  }

  void _submit() {
    final weight = tryParseKg(_weight.text);
    final reps = int.tryParse(_reps.text.trim());
    if (weight == null) {
      setState(() => _error = 'Enter a weight.');
      return;
    }
    if (reps == null || reps < 0) {
      setState(() => _error = 'Enter reps for every set.');
      return;
    }
    Navigator.pop(context, (weightKg: weight, reps: reps));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AlertDialog(
      title: Text(s.text('Edit set')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _weight,
            autofocus: true,
            decoration: InputDecoration(
              labelText: s.text('Weight (kg)'),
              errorText: _error == null ? null : s.text(_error!),
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reps,
            decoration: InputDecoration(
              labelText: s.text('Reps'),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.text('Cancel')),
        ),
        TextButton(onPressed: _submit, child: Text(s.text('Save'))),
      ],
    );
  }
}

String strengthSetLabel(double weightKg, int reps) {
  return '${formatKg(weightKg)} kg × $reps';
}
