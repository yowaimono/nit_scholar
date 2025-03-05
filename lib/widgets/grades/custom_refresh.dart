import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Widget child,
      RefreshIndicatorController controller) builder;

  CustomRefreshIndicator({
    required this.child,
    required this.builder,
  });

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  late RefreshIndicatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RefreshIndicatorController();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _controller.start();
        await Future.delayed(Duration(seconds: 2)); // 模拟刷新操作
        _controller.end();
      },
      child: widget.builder(context, widget.child, _controller),
    );
  }
}

class RefreshIndicatorController {
  double _value = 0.0;
  bool _isRefreshing = false;

  double get value => _value;
  bool get isRefreshing => _isRefreshing;

  void start() {
    _isRefreshing = true;
    _value = 0.0;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animate();
    });
  }

  void end() {
    _isRefreshing = false;
  }

  void _animate() {
    if (_isRefreshing && _value < 1.0) {
      setState(() {
        _value += 0.1;
        if (_value > 1.0) _value = 1.0;
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _animate();
      });
    }
  }

  void setState(VoidCallback callback) {
    if (mounted) {
      setState(callback);
    }
  }

  bool get mounted => context != null;

  BuildContext? context;
}

class CartoonCirclePainter extends CustomPainter {
  final double progress;

  CartoonCirclePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 绘制一个卡通风格的圆形
    final paint = Paint()
      ..color = const Color.fromARGB(255, 9, 127, 224)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    // 绘制圆弧
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progress * 2 * pi,
      false,
      paint,
    );

    // 绘制一个小圆点
    final dotPaint = Paint()..color = Colors.blue;
    final dotCenter = Offset(
      center.dx + radius * cos(progress * 2 * pi - pi / 2),
      center.dy + radius * sin(progress * 2 * pi - pi / 2),
    );
    canvas.drawCircle(dotCenter, 10.0, dotPaint);
  }

  @override
  bool shouldRepaint(CartoonCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
