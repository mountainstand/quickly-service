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
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ThemeController _themeController = Get.find();
  final LoaderController _loaderController = Get.find();

  final _emailTEC = TextEditingController();
  final _emailFN = FocusNode();

  @override
  void dispose() {
    _emailTEC.dispose();
    _emailFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.forgotPasswordQuestionMark,
          style: _themeController.title2BoldTS,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!
                  .enterYourEmailAndLinkWillBeSendToResetYourPassword,
              style: _themeController.bodyRegularGrayTS,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ThemeTextField(
                controller: _emailTEC,
                focusNode: _emailFN,
                hintText: AppLocalizations.of(context)!.enterYourEmail,
                prefixIconName: Assets().imageAssets.emailIcon,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            ThemeElevatedButton(
              onPressed: _sendOTPPressed,
              child: Text(
                AppLocalizations.of(context)!.sendOTP,
                style: _themeController.subheadlineBoldWhiteForAllModesTS,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendOTPPressed() async {
    final email = _emailTEC.text;
    if (email.isEmpty) {
      FlutterToastManager()
          .showToast(withMessage: AppLocalizations.of(context)!.enterYourEmail);
    } else if (!email.isValidEmail) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!.enterValidEmail);
    } else {
      _loaderController.showLoader();

      _loaderController.hideLoader();
      Get.to(() => OTPVerificationScreen());
    }
  }
}
