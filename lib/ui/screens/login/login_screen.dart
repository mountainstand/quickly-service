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
import 'sign_up_screen.dart';
import 'social_login_button.dart';
import 'terms_and_conditions_check_box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ThemeController _themeController = Get.find();
  final LoginController _loginController = Get.find();
  final LoaderController _loaderController = Get.find();

  final _emailTEC = TextEditingController();
  final _passwordTEC = TextEditingController();
  final _emailFN = FocusNode();
  final _passwordFN = FocusNode();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      _emailTEC.text = "test@gmail.com";
      _passwordTEC.text = "123456";
    }
  }

  @override
  void dispose() {
    _emailTEC.dispose();
    _passwordTEC.dispose();
    _emailFN.dispose();
    _passwordFN.dispose();
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
                          AppLocalizations.of(context)!.welcomeBack,
                          style: _themeController.title3BoldTS,
                        ),
                        Text(
                          AppLocalizations.of(context)!.signInToContinueUsing(
                              AppLocalizations.of(context)!.appName),
                          style: _themeController.bodyRegularGrayTS,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: padding / 1.5, bottom: padding / 3),
                          child: ThemeTextField(
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
                        ),
                        ThemeTextField(
                          controller: _passwordTEC,
                          focusNode: _passwordFN,
                          hintText: AppLocalizations.of(context)!.enterPassword,
                          prefixIconName: Assets().imageAssets.passwordIcon,
                          isPasswordField: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 5.0),
                        //   child: Align(
                        //     alignment: Alignment.centerRight,
                        //     child: TextButton(
                        //       onPressed: () {
                        //         Get.to(() => ForgotPasswordScreen());
                        //       },
                        //       child: Text(
                        //         AppLocalizations.of(context)!
                        //             .forgotPasswordQuestionMark,
                        //         style: _themeController.captionRegularTS,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TermsAndConditionsCheckBox(
                            value: true,
                            onChanged: (bool? newValue) {},
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ThemeElevatedButton(
                              onPressed: _signInPressed,
                              child: Text(AppLocalizations.of(context)!.signIn,
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
                                AppLocalizations.of(context)!.orSignInWith,
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
                                    .createNewAccountQuestionMark,
                                style: _themeController.captionRegularTS,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {},
                              ),
                              TextSpan(text: " "),
                              TextSpan(
                                text: AppLocalizations.of(context)!.signUp,
                                style:
                                    _themeController.captionMediumTextColor2TS,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.to(() => SignUpScreen());
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

  Future<void> _signInPressed() async {
    final email = _emailTEC.text;
    final password = _passwordTEC.text;
    if (email.isEmpty) {
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
    } else {
      _loaderController.showLoader();
      final result = await _loginController.loginUserWith(
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
    }
    FlutterToastManager().showToast(
      withMessage: result.message,
    );
  }
}
