import 'package:flutter/material.dart';

enum CircleClipperEnum {
  completeCircle,
  leftTitledSemiCircle,
  rightTitledSemiCircle
}

extension CircleClipperPath on CircleClipperEnum {
  Path getPath(Size size) {
    final path = Path();
    switch (this) {
      case CircleClipperEnum.completeCircle:
        path.addOval(Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width / 2));
        break;
      case CircleClipperEnum.leftTitledSemiCircle:
        path.moveTo(size.width, 0);
        path.arcToPoint(Offset(size.width, size.height),
            radius: Radius.elliptical(size.width / 2, size.height / 2),
            clockwise: false);

        path.close();
        break;
      case CircleClipperEnum.rightTitledSemiCircle:
        path.arcToPoint(Offset(0, size.height),
            radius: Radius.elliptical(size.width / 2, size.height / 2),
            clockwise: true);
        path.close();
        break;
    }

    return path;
  }
}

class CircleClipper extends CustomClipper<Path> {
  final CircleClipperEnum circleSideEnum;

  const CircleClipper({required this.circleSideEnum});

  @override
  Path getClip(Size size) => circleSideEnum.getPath(size);

  /* 
  this function tells that when changes happen to parent widget, should clip path be redrawn
  set it to true becuase size may vary
  */
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
