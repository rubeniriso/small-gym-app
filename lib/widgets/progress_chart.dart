import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gym_app/domain/models.dart';
import 'package:gym_app/domain/progression.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key, required this.points, required this.unit});

  final List<ProgressPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: CustomPaint(
        painter: _LineChartPainter(
          points: points,
          unit: unit,
          line: theme.colorScheme.primary,
          grid: theme.colorScheme.outlineVariant,
          label: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.points,
    required this.unit,
    required this.line,
    required this.grid,
    required this.label,
  });

  final List<ProgressPoint> points;
  final String unit;
  final Color line;
  final Color grid;
  final Color label;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) {
      return;
    }
    const left = 52.0;
    const bottom = 28.0;
    const top = 12.0;
    const right = 12.0;
    final plot = Rect.fromLTRB(
      left,
      top,
      size.width - right,
      size.height - bottom,
    );
    var minValue = points.map((point) => point.value).reduce(math.min);
    var maxValue = points.map((point) => point.value).reduce(math.max);
    if (minValue == maxValue) {
      minValue -= 1;
      maxValue += 1;
    } else {
      final pad = (maxValue - minValue) * 0.15;
      minValue -= pad;
      maxValue += pad;
    }

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    final linePaint = Paint()
      ..color = line
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
    final dotPaint = Paint()..color = line;

    for (var tick = 0; tick < 3; tick++) {
      final t = tick / 2;
      final y = plot.bottom - plot.height * t;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), gridPaint);
      final value = minValue + (maxValue - minValue) * t;
      _text(canvas, _shown(value), Offset(0, y - 6), label, plot.left - 4);
    }

    final path = ui.Path();
    for (var index = 0; index < points.length; index++) {
      final point = _at(plot, index, minValue, maxValue);
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawCircle(point, 4, dotPaint);
    }
    if (points.length > 1) {
      canvas.drawPath(path, linePaint);
    }

    _text(
      canvas,
      _day(points.first.day),
      Offset(plot.left, size.height - 16),
      label,
      null,
    );
    if (points.length > 1) {
      final last = _day(points.last.day);
      final width = _measure(last, label);
      _text(
        canvas,
        last,
        Offset(plot.right - width, size.height - 16),
        label,
        null,
      );
    }
  }

  Offset _at(Rect plot, int index, double minValue, double maxValue) {
    final x = points.length == 1
        ? plot.center.dx
        : plot.left + plot.width * index / (points.length - 1);
    final t = (points[index].value - minValue) / (maxValue - minValue);
    return Offset(x, plot.bottom - plot.height * t);
  }

  String _shown(double value) {
    if (unit == 'min') {
      return value.round().toString();
    }
    return formatKg(value);
  }

  String _day(DateTime day) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${day.day} ${months[day.month - 1]}';
  }

  double _measure(String text, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final width = painter.width;
    painter.dispose();
    return width;
  }

  void _text(
    Canvas canvas,
    String text,
    Offset offset,
    Color color,
    double? right,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 11),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 48);
    final dx = right == null ? offset.dx : right - painter.width;
    painter.paint(canvas, Offset(dx, offset.dy));
    painter.dispose();
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => true;
}
