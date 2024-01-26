import 'dart:math';
import 'package:flutter/material.dart';
import '/src/diary_lock.dart';
import '/src/rotatable_number.dart';
import '/src/painters/circle.painter.dart';
import '/src/painters/rotary-circle.painter.dart';

class RotaryPhone extends StatefulWidget {
  RotaryPhone({
    super.key,
    this.radius = 150.0,
    required this.onChanged,
  }) : numbers = List.generate(10, (index) {
          if (index == 0) return index.toString();
          return (10 - index).toString();
        }).reversed.toList();

  /// List of numbers
  final List<String> numbers;

  /// Radius diary
  /// default [150.0]
  final double radius;

  /// On changed
  /// when selected number
  final Function(String number) onChanged;

  @override
  State<RotaryPhone> createState() => _RotaryPhoneState();
}

class _RotaryPhoneState extends State<RotaryPhone> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController startAnimController;
  late Animation<double> anim;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: startAngle,
      upperBound: double.infinity,
    );
    startAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      lowerBound: 0,
      upperBound: 1,
    )
      ..forward()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  /// Start angle
  double startAngle = pi / 3;

  /// Sweep angle
  double sweepAngle = pi * 3 / 2;

  /// Size of circles
  double sizeCircle = 55 / 2;

  /// Size Big circle
  Size get size => Size(widget.radius * 2, widget.radius * 2);

  /// Current drag offset
  /// default [Offset.zero]
  Offset _currentDragOffset = Offset.zero;

  /// Center of circle
  Offset get center => size.center(Offset.zero);

  /// Selected index
  int selectedIndex = -1;
  String? get selectedNumber => selectedIndex == -1 ? null : widget.numbers[selectedIndex];

  /// Dragable enabled
  /// default false
  bool get dragEnable => selectedIndex != -1;

  /// Circle angle
  double get circleAngle => controller.value + (selectedIndex + 3) * (-pi / 6);

  final sizeAnim = Tween<double>(begin: 0.0, end: 1.0);

  void _onPanStart(DragStartDetails details) {
    if (controller.isAnimating) return;
    final point = details.localPosition - center;
    _currentDragOffset = point;
    _calculateStartIndex(point);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!dragEnable || controller.isAnimating) return;

    final previousOffset = _currentDragOffset;
    _currentDragOffset += details.delta;

    final currentDirection = _currentDragOffset.direction; // max 0.5
    final previousDirection = previousOffset.direction;
    final angle = controller.value + currentDirection - previousDirection;

    /// Check Locked
    if (circleAngle >= pi / 6) {
      _resetNumbers();
      return;
    }

    if (angle < pi / 3 || angle >= pi * 13 / 6) return; // max - min angle
    controller.value = angle;
  }

  /// Reset
  void _onPanEnd(DragEndDetails details) {
    if (controller.isAnimating) return;
    _resetNumbers();
  }

  /// Calculate
  /// which one number selected when started
  void _calculateStartIndex(Offset point) {
    for (int i = 0; i < widget.numbers.length; i++) {
      double widgetX = widget.radius * cos((i + 1) * -1 / 6 * pi);
      double widgetY = widget.radius * sin((i + 1) * -1 / 6 * pi);
      if ((point.dx - widgetX).abs() <= sizeCircle && (point.dy - widgetY).abs() <= sizeCircle) {
        selectedIndex = i;
        break;
      }
    }
  }

  Future<void> _resetNumbers() async {
    await controller.reverse();
    if (selectedIndex != -1) {
      widget.onChanged.call(widget.numbers[selectedIndex]);
    }
    selectedIndex = -1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: CirclePainter(
              radius: widget.radius,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (int i = 0; i < widget.numbers.length; i++) ...[
                  RotateNumber(
                    number: widget.numbers[i],
                    index: i,
                    radius: widget.radius,
                  ),
                ],
                GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: Container(
                    color: Colors.transparent,
                    child: CustomPaint(
                      size: size,
                      painter: RotaryCirclePainter(
                        radius: widget.radius,
                        startAngle: controller.value,
                        sweepAngle: sweepAngle * Curves.fastLinearToSlowEaseIn.transform(startAnimController.value),
                      ),
                    ),
                  ),
                ),

                DiaryLock(
                  number: selectedNumber,
                  radius: widget.radius,
                ),

                // Ghost widget
                Container(
                  width: widget.radius * 2 - 75,
                  height: widget.radius * 2 - 75,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
