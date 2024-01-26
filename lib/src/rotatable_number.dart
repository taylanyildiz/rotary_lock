import 'dart:math';

import 'package:flutter/material.dart';

class RotateNumber extends StatelessWidget {
  const RotateNumber({
    super.key,
    required this.number,
    required this.index,
    required this.radius,
  });

  /// Number
  final String number;

  /// Rotate index
  final int index;

  /// Radius
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset.fromDirection((index + 1) * -1 / 6 * pi, radius),
      child: Container(
        width: 55.0,
        height: 55.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          border: Border.all(width: 1, color: Colors.white38),
        ),
        alignment: Alignment.center,
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
