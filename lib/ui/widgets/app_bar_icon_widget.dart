import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, Inst;

import '../../global_controllers/theme_controller.dart';

class AppBarIconWidget extends StatelessWidget {
  final double iconSize;
  final double internalPadding;
  final bool isTappable;
  final VoidCallback? onPressed;
  final Widget child;

  AppBarIconWidget({
    super.key,
    required this.iconSize,
    this.internalPadding = 10,
    this.isTappable = true,
    this.onPressed,
    required this.child,
  });

  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: EdgeInsets.all(internalPadding),
      child: SizedBox(
        width: iconSize,
        height: iconSize,
        child: this.child,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: _themeController.borderColor,
        ),
        borderRadius: BorderRadius.circular((iconSize + internalPadding) / 1.5),
        color: _themeController.backgroundColor,
      ),
      child: isTappable
          ? onPressed == null
              ? Opacity(opacity: 0.5, child: child)
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero, // Remove internal padding
                    minimumSize:
                        Size.zero, // Allow button to shrink to child's size
                    tapTargetSize: MaterialTapTargetSize
                        .shrinkWrap, // Shrinks touch target size
                  ),
                  onPressed: onPressed,
                  child: child,
                )
          : child,
    );
  }
}
