import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants_and_extensions/assets.dart';
import '../../global_controllers/theme_controller.dart';
import 'asset_image_widget.dart';

class ThemeTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final String prefixIconName;
  final bool isPasswordField;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onSubmitted;

  const ThemeTextField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.hintText,
    required this.prefixIconName,
    this.isPasswordField = false,
    this.textInputAction = TextInputAction.done,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.onSubmitted,
  });

  @override
  State<ThemeTextField> createState() => _ThemeTextFieldState();
}

class _ThemeTextFieldState extends State<ThemeTextField> {
  final ThemeController _themeController = Get.find();

  bool _passwordHidden = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPasswordField ? _passwordHidden : false,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      onSubmitted: widget.onSubmitted,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20.0),
        hintText: widget.hintText,
        hintStyle: _themeController.bodyRegularGrayTS,
        filled: true,
        fillColor: _themeController.textFieldBGColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AssetImageWidget(
            assetName: widget.prefixIconName,
            fit: BoxFit.fitHeight,
            color: _themeController.gray,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        suffixIcon: widget.isPasswordField
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _passwordHidden = !_passwordHidden;
                    });
                  },
                  child: AssetImageWidget(
                    assetName: _passwordHidden
                        ? Assets().imageAssets.passwordVisibleIcon
                        : Assets().imageAssets.passwordInvisibleIcon,
                    fit: BoxFit.fitHeight,
                    color: _themeController.gray,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
