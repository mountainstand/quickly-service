import 'package:flutter/material.dart';

class CircleBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  CircleBorderPainter({required this.color, this.strokeWidth = 4}) : super();

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object for the border
    final Paint paint = Paint()
      ..color = color // Border color
      ..style = PaintingStyle.stroke // Draw only the border
      ..strokeWidth = strokeWidth; // Border thickness

    // Define a circular path that matches the clipper's shape
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2), // Center of the circle
      size.width / 2, // Radius of the circle
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
