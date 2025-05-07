import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants_and_extensions/assets.dart';
import '../../../constants_and_extensions/flutter_toast_manager.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../global_controllers/loader_controller.dart';
import '../../../global_controllers/login_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';
import '../../widgets/theme_elevated_button.dart';
import '../../widgets/theme_text_field.dart';
import '../../widgets/world_map_image_widget.dart';
import 'social_login_button.dart';
import 'terms_and_conditions_check_box.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final ThemeController _themeController = Get.find();
  final LoaderController _loaderController = Get.find();
  final LoginController _loginController = Get.find();

  final _nameTEC = TextEditingController();
  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  final _confirmPasswordTEC = TextEditingController();
  final _nameFN = FocusNode();
  final _emailFN = FocusNode();
  final _passwordFN = FocusNode();
  final _confirmPasswordFN = FocusNode();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _nameTEC.text = "Test";
      _emailTEC.text = "test@gmail.com";
      _passwordTEC.text = "123456";
      _confirmPasswordTEC.text = "123456";
    }
  }

  @override
  void dispose() {
    _nameTEC.dispose();
    _emailTEC.dispose();
    _passwordTEC.dispose();
    _confirmPasswordTEC.dispose();
    _nameFN.dispose();
    _emailFN.dispose();
    _passwordFN.dispose();
    _confirmPasswordFN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = 30.0;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: padding),
                child: WorldMapImageWidget(
                  assetName: Assets().imageAssets.worldMapCurvedCentered,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(),
                  Padding(
                    padding: EdgeInsets.only(
                      left: padding / 1.5,
                      right: padding / 1.5,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: padding / 1.5),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                    color: _themeController.primaryColor
                                        .withValues(alpha: 0.35),
                                  )
                                ]),
                            child: AssetImageWidget(
                              assetName: Assets().imageAssets.appIcon,
                              height: Get.width * 0.3,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.secureYourConnection,
                          style: _themeController.title3BoldTS,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .joinMillionsOfUsersProtectingTheirOnlinePrivacy,
                          style: _themeController.bodyRegularGrayTS,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: padding / 1.5, bottom: padding / 3),
                          child: ThemeTextField(
                            controller: _nameTEC,
                            focusNode: _nameFN,
                            hintText:
                                AppLocalizations.of(context)!.enterYourName,
                            prefixIconName: Assets().imageAssets.emailIcon,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            onSubmitted: (_) {
                              FocusScope.of(context).requestFocus(_emailFN);
                            },
                          ),
                        ),
                        ThemeTextField(
                          controller: _emailTEC,
                          focusNode: _emailFN,
                          hintText:
                              AppLocalizations.of(context)!.enterYourEmail,
                          prefixIconName: Assets().imageAssets.emailIcon,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          onSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFN);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: padding / 3, bottom: padding / 3),
                          child: ThemeTextField(
                            controller: _passwordTEC,
                            focusNode: _passwordFN,
                            hintText:
                                AppLocalizations.of(context)!.createPassword,
                            prefixIconName: Assets().imageAssets.passwordIcon,
                            isPasswordField: true,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_confirmPasswordFN);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: padding / 3),
                          child: ThemeTextField(
                            controller: _confirmPasswordTEC,
                            focusNode: _confirmPasswordFN,
                            hintText:
                                AppLocalizations.of(context)!.confirmPassword,
                            prefixIconName: Assets().imageAssets.passwordIcon,
                            isPasswordField: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ),
                        TermsAndConditionsCheckBox(
                          value: true,
                          onChanged: (bool? newValue) {},
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ThemeElevatedButton(
                              onPressed: _signUpPressed,
                              child: Text(AppLocalizations.of(context)!.signUp,
                                  style: _themeController
                                      .subheadlineBoldWhiteForAllModesTS),
                            )),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: _themeController.gray,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.orSignUpWith,
                                style: _themeController.captionRegularGrayTS,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: _themeController.gray,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: SocialLoginButton(
                                    assetname:
                                        Assets().imageAssets.appleLogoIcon,
                                    assetColor: _themeController.black,
                                    title: AppLocalizations.of(context)!.apple,
                                    onPressed: _appleLoginPressed),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: SocialLoginButton(
                                    assetname:
                                        Assets().imageAssets.googleLogoImage,
                                    assetColor: null,
                                    title: AppLocalizations.of(context)!.google,
                                    onPressed: _googleLoginPressed),
                              ),
                            ],
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            style: _themeController.captionRegularTS,
                            children: [
                              TextSpan(
                                text: AppLocalizations.of(context)!
                                    .alreadyhaveAnAccountQuestionMark,
                                style: _themeController.captionRegularTS,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: AppLocalizations.of(context)!.signIn,
                                style:
                                    _themeController.captionMediumTextColor2TS,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.back();
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signUpPressed() async {
    final name = _nameTEC.text;
    final email = _emailTEC.text;
    final password = _passwordTEC.text;
    final confirmPassword = _confirmPasswordTEC.text;
    if (name.isEmpty) {
      FlutterToastManager()
          .showToast(withMessage: AppLocalizations.of(context)!.enterYourName);
    } else if (email.isEmpty) {
      FlutterToastManager()
          .showToast(withMessage: AppLocalizations.of(context)!.enterYourEmail);
    } else if (!email.isValidEmail) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!.enterValidEmail);
    } else if (password.isEmpty) {
      FlutterToastManager()
          .showToast(withMessage: AppLocalizations.of(context)!.enterPassword);
    } else if (!password.isValidPassword) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!.enterValidPassword);
    } else if (confirmPassword.isEmpty) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!.enterConfirmPassword);
    } else if (confirmPassword != password) {
      FlutterToastManager().showToast(
          withMessage: AppLocalizations.of(context)!
              .passwordAndConfirmPasswordShouldMatch);
    } else {
      _loaderController.showLoader();
      final result = await _loginController.registerWith(
        name: name,
        email: email,
        password: password,
      );
      _loaderController.hideLoader();
      processLoginResult(result);
    }
  }

  Future<void> _googleLoginPressed() async {
    _loaderController.showLoader();
    final result = await _loginController.signInWithGoogle();
    _loaderController.hideLoader();
    processLoginResult(result);
  }

  Future<void> _appleLoginPressed() async {
    _loaderController.showLoader();
    final result = await _loginController.signInWithApple();
    _loaderController.hideLoader();
    processLoginResult(result);
  }

  void processLoginResult(
      ({
        bool success,
        String message,
      }) result) {
    if (result.success) {
      Get.back();
      Get.back();
    } else {}
    FlutterToastManager().showToast(
      withMessage: result.message,
    );
  }
}
