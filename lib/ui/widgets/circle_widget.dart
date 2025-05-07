import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  final double size;
  final Widget child;

  const CircleWidget({
    super.key,
    required this.size,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox.fromSize(
        size: Size.fromRadius(size / 2),
        child: child,
      ),
    );
  }
}
