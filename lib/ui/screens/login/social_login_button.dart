import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';
import '../../widgets/theme_elevated_button.dart';

class SocialLoginButton extends StatelessWidget {
  final String assetname;
  final Color? assetColor;
  final String title;
  final VoidCallback onPressed;
  final ThemeController _themeController = Get.find();

  SocialLoginButton({
    super.key,
    required this.assetname,
    required this.assetColor,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
        BoxShadow(
          blurRadius: 15,
          spreadRadius: 1,
          color: _themeController.shadowColor,
        )
      ]),
      child: ThemeElevatedButton(
        backgroundColor: _themeController.buttonSelectedColor3,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AssetImageWidget(
              assetName: assetname,
              color: assetColor,
              height: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: _themeController.bodyMediumTS,
            ),
          ],
        ),
      ),
    );
  }
}
