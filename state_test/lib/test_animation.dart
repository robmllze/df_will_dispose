import 'package:flutter/material.dart';

class TestAnimation extends StatefulWidget {
  const TestAnimation({super.key});

  @override
  _TestAnimationState createState() => _TestAnimationState();
}

class _TestAnimationState extends State<TestAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 300).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: EdgeInsets.only(left: _animation.value),
          width: 50,
          height: 50,
          color: Colors.blue,
        );
      },
    );
  }
}
