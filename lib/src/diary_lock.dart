import 'dart:math';
import 'package:flutter/material.dart';

class DiaryLock extends StatelessWidget {
  const DiaryLock({
    super.key,
    required this.number,
    required this.radius,
  });

  /// Selected number
  final String? number;

  /// Circle lock
  final double radius;

  double get _radiusLock => 75.0 / 2;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset.fromDirection(pi / 6, radius),
      child: Container(
        width: _radiusLock,
        height: _radiusLock,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Visibility(
          visible: number != null,
          child: Text(
            number ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
      ),
    );
  }
}
