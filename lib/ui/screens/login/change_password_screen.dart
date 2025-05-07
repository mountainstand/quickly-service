import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants_and_extensions/assets.dart';
import '../../../constants_and_extensions/flutter_toast_manager.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../global_controllers/loader_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/theme_elevated_button.dart';
import '../../widgets/theme_text_field.dart';
import 'login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ThemeController _themeController = Get.find();
  final LoaderController _loaderController = Get.find();

  final _newPasswordTEC = TextEditingController();
  final _newPasswordFN = FocusNode();

  final _confirmPasswordTEC = TextEditingController();
  final _confirmPasswordFN = FocusNode();

  @override
  void dispose() {
    _newPasswordTEC.dispose();
    _newPasswordFN.dispose();
    _confirmPasswordTEC.dispose();
    _confirmPasswordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.changePassword,
          style: _themeController.title2BoldTS,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!
                  .pleaseEnterYourNewPasswordAndConfirmTheNewPassword,
              style: _themeController.bodyRegularGrayTS,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ThemeTextField(
                controller: _newPasswordTEC,
                focusNode: _newPasswordFN,
                hintText: AppLocalizations.of(context)!.newPassword,
                prefixIconName: Assets().imageAssets.passwordIcon,
                isPasswordField: true,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_confirmPasswordFN);
                },
              ),
            ),
            ThemeTextField(
              controller: _confirmPasswordTEC,
              focusNode: _confirmPasswordFN,
              hintText: AppLocalizations.of(context)!.confirmPassword,
              prefixIconName: Assets().imageAssets.passwordIcon,
              isPasswordField: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: ThemeElevatedButton(
                onPressed: _savePressed,
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: _themeController.subheadlineBoldWhiteForAllModesTS,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePressed() async {
    final newPassword = _newPasswordTEC.text;
    final confirmPassword = _confirmPasswordTEC.text;
    if (newPassword.isEmpty) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!.enterNewPassword);
    } else if (!newPassword.isValidPassword) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!.enterValidPassword);
    } else if (confirmPassword.isEmpty) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!.enterConfirmPassword);
    } else if (confirmPassword != newPassword) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!
              .passwordAndConfirmPasswordShouldMatch);
    } else {
      _loaderController.showLoader();
      _loaderController.hideLoader();
      Get.until(
          (route) => route is GetPageRoute && route.page!() is LoginScreen);
    }
  }
}
