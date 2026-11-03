import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_app/domain/exercise.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/l10n/app_strings.dart';
import 'package:gym_app/widgets/duration_picker.dart';
import 'package:gym_app/widgets/gym_icons.dart';
import 'package:gym_app/widgets/increment_picker.dart';

class ExerciseTargets {
  const ExerciseTargets({
    required this.sets,
    required this.reps,
    this.weightKg,
    this.durationSeconds,
    this.speedKmh,
    this.restSeconds,
    this.increment,
    this.intervals = const [],
  });

  final int sets;
  final int reps;
  final double? weightKg;
  final int? durationSeconds;
  final double? speedKmh;
  final int? restSeconds;
  final WeightIncrement? increment;
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
  _Draft({String speed = ''}) : speed = TextEditingController(text: speed);

  _Draft.fromInterval(LoggedInterval interval)
    : seconds = interval.durationSeconds,
      speed = TextEditingController(text: formatKg(interval.speedKmh));

  int seconds = 0;
  final TextEditingController speed;

  void dispose() {
    speed.dispose();
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
  final _speed = TextEditingController();
  int? _rest;
  WeightIncrement? _increment;
  int _duration = 0;
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
          ExerciseTargets(
            sets: _sets,
            reps: _reps,
            weightKg: weight,
            restSeconds: _rest,
            increment: _increment,
          ),
        );
      case ExerciseKind.jogging:
        final speed = tryParseKg(_speed.text);
        if (_duration < 1) {
          setState(() => _error = 'Enter a duration.');
          return;
        }
        if (speed == null) {
          setState(() => _error = 'Enter a speed.');
          return;
        }
        Navigator.pop(
          context,
          ExerciseTargets(
            sets: 1,
            reps: 1,
            durationSeconds: _duration,
            speedKmh: speed,
          ),
        );
      case ExerciseKind.sprinting:
        final intervals = <LoggedInterval>[];
        for (final draft in _drafts) {
          final speed = tryParseKg(draft.speed.text);
          if (draft.seconds < 1) {
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
              durationSeconds: draft.seconds,
              unit: draft.seconds % 60 == 0
                  ? DurationUnit.minutes
                  : DurationUnit.seconds,
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
    final s = context.s;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final maxList = MediaQuery.sizeOf(context).height * 0.45;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            s.exerciseName(widget.exercise),
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            widget.exercise.kind == ExerciseKind.sprinting
                ? s.text('The first interval is the warm-up.')
                : s.text('Set the target for this exercise.'),
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
                      child: Text(s.text('Add interval')),
                    ),
                  ),
                ],
              ),
            )
          else
            ..._fields(),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              s.text(_error!),
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submit,
            child: Text(widget.editing ? s.text('Save') : s.text('Add')),
          ),
        ],
      ),
    );
  }

  Widget _intervalFields(int index) {
    final draft = _drafts[index];
    final s = context.s;
    final label = index == 0 ? s.text('Warm-up') : s.intervalLabel(index + 1);
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
                  tooltip: s.text('Remove interval'),
                  onPressed: () {
                    setState(() => _retired.add(_drafts.removeAt(index)));
                  },
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          DurationField(
            key: Key('sprint-duration-$index'),
            label: s.text('Duration'),
            seconds: draft.seconds == 0 ? null : draft.seconds,
            maxMinutes: sprintMaxMinutes,
            onChanged: (seconds) {
              setState(() => draft.seconds = seconds ?? 0);
            },
          ),
          const SizedBox(height: 8),
          TextField(
            key: Key('sprint-speed-$index'),
            controller: draft.speed,
            decoration: InputDecoration(
              labelText: s.text('Speed (km/h)'),
              border: const OutlineInputBorder(),
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
    final s = context.s;
    switch (widget.exercise.kind) {
      case ExerciseKind.strength:
        return [
          _CountRow(
            label: s.text('Sets'),
            value: _sets,
            onChanged: (value) => setState(() => _sets = value),
          ),
          _CountRow(
            label: s.text('Reps'),
            value: _reps,
            onChanged: (value) => setState(() => _reps = value),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _weight,
            decoration: InputDecoration(
              labelText: s.text('Weight (kg)'),
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              DurationField(
                label: s.text('Rest'),
                seconds: _rest,
                maxMinutes: restMaxMinutes,
                clearable: true,
                compact: true,
                icon: const StopwatchIcon(),
                onChanged: (seconds) => setState(() => _rest = seconds),
              ),
              const SizedBox(width: 16),
              IncrementField(
                label: s.text('Weight increments'),
                increment: _increment,
                clearable: true,
                compact: true,
                onChanged: (increment) =>
                    setState(() => _increment = increment),
              ),
            ],
          ),
        ];
      case ExerciseKind.jogging:
        return [
          DurationField(
            key: const Key('jogging-duration'),
            label: s.text('Duration'),
            seconds: _duration == 0 ? null : _duration,
            maxMinutes: jogMaxMinutes,
            onChanged: (seconds) => setState(() => _duration = seconds ?? 0),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _speed,
            decoration: InputDecoration(
              labelText: s.text('Speed (km/h)'),
              border: const OutlineInputBorder(),
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
    final s = context.s;
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 88),
          child: Text(label),
        ),
        IconButton(
          tooltip: s.fewer(label),
          onPressed: value <= 1 ? null : () => onChanged(value - 1),
          icon: const Icon(Icons.remove),
        ),
        SizedBox(width: 24, child: Text('$value', textAlign: TextAlign.center)),
        IconButton(
          tooltip: s.more(label),
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
