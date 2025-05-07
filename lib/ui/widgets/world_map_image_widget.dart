import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, Inst;

import '../../global_controllers/theme_controller.dart';
import 'asset_image_widget.dart';

class WorldMapImageWidget extends StatelessWidget {
  final double opacity;
  final String assetName;
  final double? height;

  WorldMapImageWidget({
    super.key,
    this.opacity = 0.25,
    this.height,
    required this.assetName,
  });

  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: AssetImageWidget(
        assetName: assetName,
        height: height,
        fit: BoxFit.cover,
        color: _themeController.gray,
      ),
    );
  }
}
