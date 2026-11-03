import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/domain/sprint.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/widgets/gym_icons.dart';

const restMaxMinutes = 60;
const sprintMaxMinutes = 60;
const jogMaxMinutes = 180;

const _secondStep = 5;
const _secondMax = 55;

/// Snaps a length onto the picker steps: whole minutes, seconds by five.
int snapDurationSeconds(int totalSeconds, {required int maxMinutes}) {
  final cap = maxMinutes < 1 ? 1 : maxMinutes;
  final safe = totalSeconds < 0 ? 0 : totalSeconds;
  var minutes = safe ~/ 60;
  var seconds = ((safe % 60) / _secondStep).round() * _secondStep;
  if (seconds >= 60) {
    minutes += 1;
    seconds = 0;
  }
  if (minutes > cap) {
    minutes = cap;
    seconds = 0;
  }
  return minutes * 60 + seconds;
}

class DurationSelection {
  const DurationSelection(this.seconds) : cleared = false;

  const DurationSelection.cleared() : seconds = null, cleared = true;

  final int? seconds;
  final bool cleared;
}

Future<DurationSelection?> showDurationPicker(
  BuildContext context, {
  String? title,
  required int initialSeconds,
  int maxMinutes = restMaxMinutes,
  bool clearable = false,
}) {
  return showDialog<DurationSelection>(
    context: context,
    builder: (context) => _DurationDialog(
      title: title,
      initialSeconds: snapDurationSeconds(
        initialSeconds,
        maxMinutes: maxMinutes,
      ),
      maxMinutes: maxMinutes < 1 ? 1 : maxMinutes,
      clearable: clearable,
    ),
  );
}

class _DurationDialog extends StatefulWidget {
  const _DurationDialog({
    required this.title,
    required this.initialSeconds,
    required this.maxMinutes,
    required this.clearable,
  });

  final String? title;
  final int initialSeconds;
  final int maxMinutes;
  final bool clearable;

  @override
  State<_DurationDialog> createState() => _DurationDialogState();
}

class _DurationDialogState extends State<_DurationDialog> {
  static const _itemExtent = 36.0;
  static const _visibleItems = 5;

  late int _minutes;
  late int _seconds;
  late final FixedExtentScrollController _minuteWheel;
  late final FixedExtentScrollController _secondWheel;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialSeconds ~/ 60;
    _seconds = widget.initialSeconds % 60;
    _minuteWheel = FixedExtentScrollController(initialItem: _minutes);
    _secondWheel = FixedExtentScrollController(
      initialItem: _seconds ~/ _secondStep,
    );
  }

  @override
  void dispose() {
    _minuteWheel.dispose();
    _secondWheel.dispose();
    super.dispose();
  }

  int get _total => _minutes * 60 + _seconds;

  TextStyle _style(BuildContext context, bool selected) {
    final scheme = Theme.of(context).colorScheme;
    return TextStyle(
      fontSize: 22,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
    );
  }

  Widget _wheel({
    required Key key,
    required FixedExtentScrollController controller,
    required int count,
    required ValueChanged<int> onSelected,
    required Widget Function(int index) child,
  }) {
    return CupertinoPicker.builder(
      key: key,
      scrollController: controller,
      itemExtent: _itemExtent,
      diameterRatio: 2.4,
      squeeze: 1.05,
      magnification: 1.12,
      useMagnifier: true,
      backgroundColor: Colors.transparent,
      selectionOverlay: const SizedBox.shrink(),
      onSelectedItemChanged: onSelected,
      childCount: count,
      itemBuilder: (context, index) => Center(child: child(index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: widget.title == null ? null : Text(widget.title!),
      content: SizedBox(
        height: _itemExtent * _visibleItems,
        width: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: _itemExtent,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: _wheel(
                    key: const Key('duration-minutes'),
                    controller: _minuteWheel,
                    count: widget.maxMinutes + 1,
                    onSelected: (index) => setState(() => _minutes = index),
                    child: (index) => Text(
                      '$index',
                      style: _style(context, index == _minutes),
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                Expanded(
                  child: _wheel(
                    key: const Key('duration-seconds'),
                    controller: _secondWheel,
                    count: (_secondMax ~/ _secondStep) + 1,
                    onSelected: (index) {
                      setState(() => _seconds = index * _secondStep);
                    },
                    child: (index) {
                      final seconds = index * _secondStep;
                      return Text(
                        seconds.toString().padLeft(2, '0'),
                        style: _style(context, seconds == _seconds),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.s.text('Cancel')),
        ),
        if (widget.clearable)
          TextButton(
            onPressed: () =>
                Navigator.pop(context, const DurationSelection.cleared()),
            child: Text(context.s.text('Use routine default')),
          ),
        TextButton(
          key: const Key('duration-save'),
          onPressed: () => Navigator.pop(context, DurationSelection(_total)),
          child: Text(context.s.text('Save')),
        ),
      ],
    );
  }
}

class DurationField extends StatelessWidget {
  const DurationField({
    super.key,
    required this.label,
    required this.seconds,
    required this.onChanged,
    this.maxMinutes = restMaxMinutes,
    this.clearable = false,
    this.hint = 'Tap to set',
    this.icon,
    this.compact = false,
  });

  final String label;
  final int? seconds;
  final int maxMinutes;
  final bool clearable;
  final String hint;
  final Widget? icon;
  final bool compact;
  final ValueChanged<int?> onChanged;

  Future<void> _open(BuildContext context) async {
    final result = await showDurationPicker(
      context,
      title: compact ? null : label,
      initialSeconds: seconds ?? 0,
      maxMinutes: maxMinutes,
      clearable: clearable,
    );
    if (result == null) {
      return;
    }
    if (result.cleared) {
      onChanged(null);
      return;
    }
    onChanged(result.seconds ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    final shown = seconds == null
        ? (compact
              ? '—'
              : (hint == 'Tap to set' ? context.s.text('Tap to set') : hint))
        : formatDuration(seconds!);
    if (compact) {
      return IconValueButton(
        icon: icon ?? const StopwatchIcon(),
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
          suffixIcon: icon,
        ),
        child: Text(shown),
      ),
    );
  }
}
