import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/l10n/app_strings.dart';

/// The set the lifter just finished, with edit and done controls.
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
    this.caption,
  });

  final String exerciseKey;
  final int setIndex;
  final String label;
  final bool placeholder;
  final bool done;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  /// Small line above [label], such as the exercise and set number.
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = context.s;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 10, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (caption != null)
                    Text(
                      caption!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: placeholder ? scheme.onSurfaceVariant : null,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              key: Key('edit-set-$exerciseKey-$setIndex'),
              tooltip: s.text('Edit set'),
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            const SizedBox(width: 4),
            IconButton(
              key: Key('set-$exerciseKey-$setIndex'),
              tooltip: s.text('Set done'),
              isSelected: done,
              onPressed: onToggle,
              style: IconButton.styleFrom(
                fixedSize: const Size(48, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                backgroundColor: done ? scheme.primary : null,
                foregroundColor: done ? scheme.onPrimary : scheme.primary,
                side: done ? null : BorderSide(color: scheme.outline),
              ),
              icon: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}

/// Up to five set buttons per row, each the same width.
class SetPillGrid extends StatelessWidget {
  const SetPillGrid({super.key, required this.children});

  final List<Widget> children;

  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = children.length.clamp(1, 5);
        final width = (constraints.maxWidth - _gap * (columns - 1)) / columns;
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

/// One planned set: reps on top, kilograms below. Tap marks it done,
/// long-press edits it.
class SetPill extends StatelessWidget {
  const SetPill({
    super.key,
    required this.setIndex,
    required this.kg,
    required this.reps,
    required this.targetReps,
    required this.placeholder,
    required this.done,
    required this.onEdit,
    required this.onToggle,
  });

  final int setIndex;
  final double kg;
  final int reps;
  final int targetReps;
  final bool placeholder;
  final bool done;
  final VoidCallback onEdit;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final short = done && reps < targetReps;
    final (Color? background, Color foreground) = switch ((done, short)) {
      (true, true) =>
        dark
            ? (const Color(0xFF5C2A12), const Color(0xFFFFDBCB))
            : (const Color(0xFFFFDBCB), const Color(0xFF5C1A00)),
      (true, false) => (scheme.primary, scheme.onPrimary),
      _ => (null, placeholder ? scheme.onSurfaceVariant : scheme.onSurface),
    };
    final s = context.s;
    final label = strengthSetLabel(kg, reps);
    return Semantics(
      button: true,
      checked: done,
      label: '${s.setNumber(setIndex + 1)}, $label',
      onLongPressHint: s.text('Edit set'),
      excludeSemantics: true,
      child: Material(
        color: background ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: done
              ? BorderSide.none
              : BorderSide(color: scheme.outline, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggle,
          onLongPress: onEdit,
          child: SizedBox(
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$reps',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: foreground,
                    fontWeight: done ? FontWeight.w700 : FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                Text(
                  formatKg(kg),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
