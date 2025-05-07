import 'package:flutter/material.dart';

class ThemeElevatedButton extends StatelessWidget {
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? strokeColor;
  final double? strokeWidth;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final Widget child;

  const ThemeElevatedButton({
    super.key,
    this.backgroundColor,
    this.borderRadius,
    this.strokeColor,
    this.strokeWidth,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: strokeColor ?? Colors.transparent,
            width: strokeWidth ?? 0,
          ),
          borderRadius: BorderRadius.circular(
            borderRadius ?? 50,
          ),
        ),
        minimumSize: Size(double.infinity, 0),
      ),
      child: padding != null
          ? Padding(
              padding: padding!,
              child: child,
            )
          : child,
    );
  }
}
