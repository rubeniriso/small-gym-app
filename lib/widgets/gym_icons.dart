import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Stopwatch drawn for the rest control.
class StopwatchIcon extends StatelessWidget {
  const StopwatchIcon({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ink = color ?? IconTheme.of(context).color ?? const Color(0xFF000000);
    return CustomPaint(
      size: Size.square(size),
      painter: _StopwatchPainter(ink),
    );
  }
}

class _StopwatchPainter extends CustomPainter {
  const _StopwatchPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final width = size.width;
    final height = size.height;
    final center = Offset(width * 0.5, height * 0.58);
    final radius = width * 0.32;

    canvas.drawCircle(center, radius, paint);
    canvas.drawLine(
      Offset(width * 0.38, height * 0.16),
      Offset(width * 0.62, height * 0.16),
      paint,
    );
    canvas.drawLine(
      Offset(width * 0.5, height * 0.16),
      Offset(width * 0.5, height * 0.26),
      paint,
    );
    canvas.drawLine(
      Offset(width * 0.72, height * 0.22),
      Offset(width * 0.80, height * 0.14),
      paint,
    );
    canvas.drawLine(center, Offset(width * 0.5, height * 0.38), paint);
    canvas.drawLine(center, Offset(width * 0.66, height * 0.66), paint);
    canvas.drawCircle(center, width * 0.035, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant _StopwatchPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

/// Icon with its value beside it. The value is the only label.
class IconValueButton extends StatelessWidget {
  const IconValueButton({
    super.key,
    required this.icon,
    required this.value,
    required this.onPressed,
  });

  final Widget icon;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [icon, const SizedBox(width: 8), Text(value)],
        ),
      ),
    );
  }
}

/// Barbell with an upward arrow, drawn for the increment control.
class PlateUpIcon extends StatelessWidget {
  const PlateUpIcon({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ink = color ?? IconTheme.of(context).color ?? const Color(0xFF000000);
    return CustomPaint(size: Size.square(size), painter: _PlateUpPainter(ink));
  }
}

class _PlateUpPainter extends CustomPainter {
  const _PlateUpPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final width = size.width;
    final height = size.height;

    canvas.drawLine(
      Offset(width * 0.18, height * 0.68),
      Offset(width * 0.82, height * 0.68),
      stroke,
    );
    _plate(
      canvas,
      fill,
      width * 0.10,
      height * 0.48,
      width * 0.14,
      height * 0.40,
    );
    _plate(
      canvas,
      fill,
      width * 0.76,
      height * 0.48,
      width * 0.14,
      height * 0.40,
    );
    _plate(
      canvas,
      fill,
      width * 0.22,
      height * 0.56,
      width * 0.08,
      height * 0.24,
    );
    _plate(
      canvas,
      fill,
      width * 0.70,
      height * 0.56,
      width * 0.08,
      height * 0.24,
    );

    final tip = Offset(width * 0.5, height * 0.08);
    final shaftEnd = Offset(width * 0.5, height * 0.40);
    canvas.drawLine(shaftEnd, tip, stroke);
    canvas.drawLine(tip, Offset(width * 0.34, height * 0.24), stroke);
    canvas.drawLine(tip, Offset(width * 0.66, height * 0.24), stroke);
  }

  void _plate(
    Canvas canvas,
    Paint paint,
    double left,
    double top,
    double plateWidth,
    double plateHeight,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, plateWidth, plateHeight),
        Radius.circular(math.min(plateWidth, plateHeight) * 0.2),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _PlateUpPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
