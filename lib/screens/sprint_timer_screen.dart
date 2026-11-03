import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';
import 'package:gym_app/domain/sprint.dart';
import 'package:gym_app/l10n/app_strings.dart';

class SprintTimerScreen extends StatefulWidget {
  const SprintTimerScreen({
    super.key,
    required this.intervals,
    this.grace = const Duration(seconds: 5),
  });

  final List<LoggedInterval> intervals;
  final Duration grace;

  @override
  State<SprintTimerScreen> createState() => _SprintTimerScreenState();
}

class _SprintTimerScreenState extends State<SprintTimerScreen>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late SprintPhase _phase;
  var _started = false;
  var _finished = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _phase = _current(Duration.zero);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  SprintPhase _current(Duration elapsed) {
    return sprintPhase(
      started: _started,
      elapsed: elapsed,
      grace: widget.grace,
      intervals: widget.intervals,
    );
  }

  void _onTick(Duration elapsed) {
    if (!mounted || _finished) {
      return;
    }
    final phase = _current(elapsed);
    if (phase.kind == SprintPhaseKind.done) {
      _finished = true;
      _ticker.stop();
      Navigator.of(context).pop(widget.intervals);
      return;
    }
    setState(() => _phase = phase);
  }

  void _start() {
    if (_started || widget.intervals.isEmpty) {
      return;
    }
    setState(() {
      _started = true;
      _phase = _current(Duration.zero);
    });
    _ticker.start();
  }

  void _stop() {
    if (_finished) {
      return;
    }
    _finished = true;
    _ticker.stop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final s = context.s;
    final total = widget.intervals.length;
    final index = _phase.intervalIndex;
    final interval = total == 0 ? null : widget.intervals[index];
    final title = switch (_phase.kind) {
      SprintPhaseKind.grace => s.text('Get ready'),
      SprintPhaseKind.idle ||
      SprintPhaseKind.interval ||
      SprintPhaseKind.done =>
        index == 0 ? s.text('Warm-up') : s.text('Interval'),
    };
    final next = index == 0 ? s.text('Warm-up') : s.intervalLabel(index + 1);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(s.text('Sprint')),
        leading: BackButton(onPressed: _stop),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final minHeight = (constraints.maxHeight - 48).clamp(
              0.0,
              double.infinity,
            );
            final minWidth = (constraints.maxWidth - 48).clamp(
              0.0,
              double.infinity,
            );
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: minWidth,
                  minHeight: minHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    if (interval != null) ...[
                      Text(
                        '${formatKg(interval.speedKmh)} km/h',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      if (_phase.kind == SprintPhaseKind.grace)
                        Text(
                          s.nextUp(next),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      Text(
                        '${_phase.number(total)}/$total',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CustomPaint(
                        key: const Key('sprint-ring'),
                        painter: SprintRingPainter(
                          progress: _phase.progress,
                          color: scheme.primary,
                          track: scheme.surfaceContainerHighest,
                        ),
                        child: Center(
                          child: Text(
                            formatCountdown(_phase.remaining),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (!_started)
                      FilledButton(
                        onPressed: _start,
                        child: Text(s.text('Start')),
                      )
                    else
                      TextButton(onPressed: _stop, child: Text(s.text('Stop'))),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SprintRingPainter extends CustomPainter {
  const SprintRingPainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 12.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - stroke / 2;
    final background = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    canvas.drawCircle(center, radius, background);
    final sweep = sprintRingSweep(progress);
    if (sweep <= 0) {
      return;
    }
    final foreground = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      sprintRingStartAngle,
      sweep,
      false,
      foreground,
    );
  }

  @override
  bool shouldRepaint(SprintRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.track != track;
  }
}
