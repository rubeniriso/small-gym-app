import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/widgets/gym_icons.dart';

class IncrementSelection {
  const IncrementSelection(this.increment) : cleared = false;

  const IncrementSelection.cleared() : increment = null, cleared = true;

  final WeightIncrement? increment;
  final bool cleared;
}

Future<IncrementSelection?> showIncrementPicker(
  BuildContext context, {
  String? title,
  required WeightIncrement initial,
  bool clearable = false,
}) {
  return showDialog<IncrementSelection>(
    context: context,
    builder: (context) =>
        _IncrementDialog(title: title, initial: initial, clearable: clearable),
  );
}

class _IncrementDialog extends StatefulWidget {
  const _IncrementDialog({
    required this.title,
    required this.initial,
    required this.clearable,
  });

  final String? title;
  final WeightIncrement initial;
  final bool clearable;

  @override
  State<_IncrementDialog> createState() => _IncrementDialogState();
}

class _IncrementDialogState extends State<_IncrementDialog> {
  late IncrementUnit _unit;
  late final TextEditingController _amount;
  String? _error;

  @override
  void initState() {
    super.initState();
    _unit = widget.initial.unit;
    _amount = TextEditingController(text: formatKg(widget.initial.amount));
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    final amount = tryParseKg(_amount.text);
    if (amount == null) {
      setState(() => _error = 'Enter an amount.');
      return;
    }
    Navigator.pop(
      context,
      IncrementSelection(WeightIncrement(unit: _unit, amount: amount)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title!),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<IncrementUnit>(
            showSelectedIcon: false,
            segments: [
              for (final unit in IncrementUnit.values)
                ButtonSegment(value: unit, label: Text(unit.label)),
            ],
            selected: {_unit},
            onSelectionChanged: (selection) {
              setState(() => _unit = selection.first);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amount,
            autofocus: true,
            decoration: InputDecoration(
              labelText: s.text('Amount'),
              errorText: _error == null ? null : s.text(_error!),
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onSubmitted: (_) => _save(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.text('Cancel')),
        ),
        if (widget.clearable)
          TextButton(
            onPressed: () =>
                Navigator.pop(context, const IncrementSelection.cleared()),
            child: Text(s.text('Use routine default')),
          ),
        TextButton(
          key: const Key('increment-save'),
          onPressed: _save,
          child: Text(s.text('Save')),
        ),
      ],
    );
  }
}

class IncrementField extends StatelessWidget {
  const IncrementField({
    super.key,
    required this.label,
    required this.increment,
    required this.onChanged,
    this.clearable = false,
    this.hint = 'Routine default',
    this.fallback = standardIncrement,
    this.compact = false,
  });

  final String label;
  final WeightIncrement? increment;
  final bool clearable;
  final String hint;
  final WeightIncrement fallback;
  final bool compact;
  final ValueChanged<WeightIncrement?> onChanged;

  Future<void> _open(BuildContext context) async {
    final result = await showIncrementPicker(
      context,
      title: compact ? null : label,
      initial: increment ?? fallback,
      clearable: clearable,
    );
    if (result == null) {
      return;
    }
    if (result.cleared) {
      onChanged(null);
      return;
    }
    onChanged(result.increment);
  }

  @override
  Widget build(BuildContext context) {
    final shown = increment == null
        ? (compact
              ? '—'
              : (hint == 'Routine default'
                    ? context.s.text('Routine default')
                    : hint))
        : formatIncrement(increment!);
    if (compact) {
      return IconValueButton(
        icon: const PlateUpIcon(),
        value: shown,
        onPressed: () => _open(context),
      );
    }
    return InkWell(
      onTap: () => _open(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const PlateUpIcon(),
        ),
        child: Text(shown),
      ),
    );
  }
}
