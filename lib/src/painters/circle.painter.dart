import 'dart:math';

import 'package:flutter/material.dart';

Paint _paint(Color color, double thickness) {
  return Paint()
    ..color = color
    ..strokeWidth = thickness
    ..style = PaintingStyle.stroke;
}

class CirclePainter extends CustomPainter {
  const CirclePainter({
    double? radius,
    Color? color,
    double? strokeWidth,
  })  : radius = radius ?? 150.0,
        color = color ?? Colors.black,
        strokeWidth = strokeWidth ?? 80.0;

  /// Circle radius
  /// default [150.0]
  final double radius;

  /// Circle background color
  /// default [Color.black]
  final Color color;

  /// Circle thickness
  /// [double] default [20]
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = _paint(color, strokeWidth);
    final center = size.center(Offset.zero);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.0,
      pi * 2,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
