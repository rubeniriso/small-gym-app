import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';

class ExerciseTargets {
  const ExerciseTargets({
    required this.sets,
    required this.reps,
    this.weightKg,
    this.minutes,
    this.speedKmh,
    this.intervals = const [],
  });

  final int sets;
  final int reps;
  final double? weightKg;
  final int? minutes;
  final double? speedKmh;
  final List<LoggedInterval> intervals;
}

Future<ExerciseTargets?> showExerciseTargets(
  BuildContext context,
  Exercise exercise, {
  List<LoggedInterval> intervals = const [],
  bool editing = false,
}) {
  return showModalBottomSheet<ExerciseTargets>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => _TargetSheet(
      exercise: exercise,
      intervals: intervals,
      editing: editing,
    ),
  );
}

class _Draft {
  _Draft({String duration = '', String speed = ''})
    : duration = TextEditingController(text: duration),
      speed = TextEditingController(text: speed);

  _Draft.fromInterval(LoggedInterval interval)
    : duration = TextEditingController(text: _amount(interval)),
      speed = TextEditingController(text: formatKg(interval.speedKmh)),
      unit = _unit(interval);

  final TextEditingController duration;
  final TextEditingController speed;
  DurationUnit unit = DurationUnit.seconds;

  void dispose() {
    duration.dispose();
    speed.dispose();
  }

  static String _amount(LoggedInterval interval) {
    if (_unit(interval) == DurationUnit.minutes) {
      return '${interval.durationSeconds ~/ 60}';
    }
    return '${interval.durationSeconds}';
  }

  static DurationUnit _unit(LoggedInterval interval) {
    if (interval.unit == DurationUnit.minutes &&
        interval.durationSeconds % 60 == 0) {
      return DurationUnit.minutes;
    }
    return DurationUnit.seconds;
  }
}

class _TargetSheet extends StatefulWidget {
  const _TargetSheet({
    required this.exercise,
    required this.intervals,
    required this.editing,
  });

  final Exercise exercise;
  final List<LoggedInterval> intervals;
  final bool editing;

  @override
  State<_TargetSheet> createState() => _TargetSheetState();
}

class _TargetSheetState extends State<_TargetSheet> {
  var _sets = 5;
  var _reps = 5;
  final _weight = TextEditingController();
  final _minutes = TextEditingController();
  final _speed = TextEditingController();
  late final List<_Draft> _drafts;
  final _retired = <_Draft>[];
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.exercise.kind != ExerciseKind.strength) {
      _sets = 1;
      _reps = 1;
    }
    _drafts = widget.intervals.isEmpty
        ? [_Draft()]
        : [
            for (final interval in widget.intervals)
              _Draft.fromInterval(interval),
          ];
  }

  @override
  void dispose() {
    _weight.dispose();
    _minutes.dispose();
    _speed.dispose();
    for (final draft in [..._drafts, ..._retired]) {
      draft.dispose();
    }
    super.dispose();
  }

  void _submit() {
    switch (widget.exercise.kind) {
      case ExerciseKind.strength:
        final weight = tryParseKg(_weight.text);
        if (weight == null) {
          setState(() => _error = 'Enter a weight.');
          return;
        }
        Navigator.pop(
          context,
          ExerciseTargets(sets: _sets, reps: _reps, weightKg: weight),
        );
      case ExerciseKind.jogging:
        final minutes = int.tryParse(_minutes.text.trim());
        final speed = tryParseKg(_speed.text);
        if (minutes == null || minutes < 1) {
          setState(() => _error = 'Enter the minutes.');
          return;
        }
        if (speed == null) {
          setState(() => _error = 'Enter a speed.');
          return;
        }
        Navigator.pop(
          context,
          ExerciseTargets(sets: 1, reps: 1, minutes: minutes, speedKmh: speed),
        );
      case ExerciseKind.sprinting:
        final intervals = <LoggedInterval>[];
        for (final draft in _drafts) {
          final amount = int.tryParse(draft.duration.text.trim());
          final speed = tryParseKg(draft.speed.text);
          if (amount == null || amount < 1) {
            setState(() => _error = 'Enter a duration for every interval.');
            return;
          }
          if (speed == null) {
            setState(() => _error = 'Enter a speed for every interval.');
            return;
          }
          intervals.add(
            LoggedInterval(
              speedKmh: speed,
              durationSeconds: draft.unit == DurationUnit.minutes
                  ? amount * 60
                  : amount,
              unit: draft.unit,
            ),
          );
        }
        Navigator.pop(
          context,
          ExerciseTargets(
            sets: intervals.length,
            reps: 1,
            intervals: intervals,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final maxList = MediaQuery.sizeOf(context).height * 0.45;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.exercise.label, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            widget.exercise.kind == ExerciseKind.sprinting
                ? 'The first interval is the warm-up.'
                : 'Set the target for this exercise.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.exercise.kind == ExerciseKind.sprinting)
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxList),
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (var index = 0; index < _drafts.length; index++)
                    _intervalFields(index),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () => setState(() => _drafts.add(_Draft())),
                      child: const Text('Add interval'),
                    ),
                  ),
                ],
              ),
            )
          else
            ..._fields(),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submit,
            child: Text(widget.editing ? 'Save' : 'Add'),
          ),
        ],
      ),
    );
  }

  Widget _intervalFields(int index) {
    final draft = _drafts[index];
    final label = index == 0 ? 'Warm-up' : 'Interval ${index + 1}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              if (index > 0)
                IconButton(
                  tooltip: 'Remove interval',
                  onPressed: () {
                    setState(() => _retired.add(_drafts.removeAt(index)));
                  },
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          TextField(
            key: Key('sprint-duration-$index'),
            controller: draft.duration,
            decoration: const InputDecoration(
              labelText: 'Duration',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<DurationUnit>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: DurationUnit.seconds, label: Text('Sec')),
                ButtonSegment(value: DurationUnit.minutes, label: Text('Min')),
              ],
              selected: {draft.unit},
              onSelectionChanged: (selection) {
                setState(() => draft.unit = selection.first);
              },
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            key: Key('sprint-speed-$index'),
            controller: draft.speed,
            decoration: const InputDecoration(
              labelText: 'Speed (km/h)',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _fields() {
    switch (widget.exercise.kind) {
      case ExerciseKind.strength:
        return [
          _CountRow(
            label: 'Sets',
            value: _sets,
            onChanged: (value) => setState(() => _sets = value),
          ),
          _CountRow(
            label: 'Reps',
            value: _reps,
            onChanged: (value) => setState(() => _reps = value),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _weight,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
        ];
      case ExerciseKind.jogging:
        return [
          TextField(
            controller: _minutes,
            decoration: const InputDecoration(
              labelText: 'Minutes',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _speed,
            decoration: const InputDecoration(
              labelText: 'Speed (km/h)',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
        ];
      case ExerciseKind.sprinting:
        return const [];
    }
  }
}

class _CountRow extends StatelessWidget {
  const _CountRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 88, child: Text(label)),
        IconButton(
          tooltip: 'Fewer ${label.toLowerCase()}',
          onPressed: value <= 1 ? null : () => onChanged(value - 1),
          icon: const Icon(Icons.remove),
        ),
        SizedBox(width: 24, child: Text('$value', textAlign: TextAlign.center)),
        IconButton(
          tooltip: 'More ${label.toLowerCase()}',
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
