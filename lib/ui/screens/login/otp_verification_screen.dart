import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';

import '../../../constants_and_extensions/flutter_toast_manager.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../global_controllers/loader_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/theme_elevated_button.dart';
import 'change_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final ThemeController _themeController = Get.find();
  final LoaderController _loaderController = Get.find();

  String _otp = "";

  @override
  Widget build(BuildContext context) {
    final padding = 16.0;
    final otpFields = 4;
    final otpFieldInternalPadding = 8.0;
    (Get.width, "Here full").log();
    ((Get.width - padding) / 4, "Here single").log();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          AppLocalizations.of(context)!.otpVerification,
          style: _themeController.title2BoldTS,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(children: [
          Text(
            AppLocalizations.of(context)!
                .pleaseEnterTheCodeWeJustSendToYourAccount("asd"),
            style: _themeController.bodyRegularGrayTS,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: OtpTextField(
              numberOfFields: otpFields,
              enabledBorderColor: Colors.transparent,
              focusedBorderColor: _themeController.primaryColor,
              disabledBorderColor: Colors.transparent,
              filled: true,
              fillColor: _themeController.textFieldBGColor,
              showFieldAsBox: true,
              borderRadius: BorderRadius.circular(10.0),
              fieldWidth: (Get.width -
                      (padding * 2) -
                      (otpFieldInternalPadding * otpFields)) /
                  otpFields,
              margin: EdgeInsets.only(right: otpFieldInternalPadding),
              onCodeChanged: (String value) {
                _otp = value;
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                _otp = verificationCode;
              }, // end onSubmit
            ),
          ),
          ThemeElevatedButton(
            onPressed: _submitPressed,
            child: Text(
              AppLocalizations.of(context)!.submit,
              style: _themeController.subheadlineBoldWhiteForAllModesTS,
            ),
          ),
          Spacer(),
          Text(
            AppLocalizations.of(context)!
                .didnotReceiveVerificationCodeQuestionMark,
            style: _themeController.bodyRegularTS,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                AppLocalizations.of(context)!.resendCode,
                style: _themeController.bodyMediumUnderlineTS,
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _submitPressed() async {
    if (_otp.length != 4) {
      FlutterToastManager()
          .showToast(withMessage: AppLocalizations.of(context)!.enterValidOTP);
    } else {
      _loaderController.showLoader();
      _loaderController.hideLoader();
      Get.off(() => ChangePasswordScreen());
    }
  }
}
