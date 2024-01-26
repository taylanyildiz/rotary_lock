import 'dart:math';
import 'package:flutter/material.dart';

Paint _arcPaint(Color color, double thickness) {
  return Paint()
    ..color = color
    ..strokeWidth = thickness
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
}

Paint _circlePaint(Color color, [bool? blendable]) {
  return Paint()
    ..color = color
    ..style = PaintingStyle.fill
    ..blendMode = blendable == true ? BlendMode.clear : BlendMode.color;
}

class RotaryCirclePainter extends CustomPainter {
  const RotaryCirclePainter({
    double? radius,
    Color? color,
    double? strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
  })  : radius = radius ?? 150.0,
        color = color ?? Colors.white,
        strokeWidth = strokeWidth ?? 75.0;

  /// Circle radius
  /// default [130.0]
  final double radius;

  /// Circle background color
  /// default [Color.black]
  final Color color;

  /// Circle thickness
  /// [double] default [20]
  final double strokeWidth;

  /// Start angle
  final double startAngle;

  /// Sweep angle
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = _arcPaint(color, strokeWidth);
    final center = size.center(Offset.zero);
    canvas
      ..saveLayer(Rect.largest, paint)
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    _drawDials(canvas, center);
    _drawDialLock(canvas, center);
    canvas.restore();
  }

  void _drawDials(Canvas canvas, Offset center) {
    for (int i = 0; i < 10; i++) {
      final offset = Offset.fromDirection(
        startAngle + (i + 3) * -pi / 6,
        radius,
      );
      final paint = _circlePaint(Colors.black, true);
      canvas.drawCircle(center + offset, 55 / 2, paint);
    }
  }

  void _drawDialLock(Canvas canvas, Offset center) {
    final offset = Offset.fromDirection(pi / 6, radius);
    final paint = _circlePaint(Colors.white, true);
    canvas.drawCircle(offset + center, strokeWidth / 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
