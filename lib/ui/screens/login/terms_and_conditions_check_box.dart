import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../global_controllers/theme_controller.dart';

class TermsAndConditionsCheckBox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;

  TermsAndConditionsCheckBox(
      {super.key, required this.value, required this.onChanged});

  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: _themeController.captionRegularTS,
              children: [
                TextSpan(
                    text: AppLocalizations.of(context)!
                        .byContinuingYouAgreeToOur),
                TextSpan(text: " "),
                TextSpan(
                  text: AppLocalizations.of(context)!.termsOfService,
                  style: _themeController.captionMediumTextColor2nderlineTS,
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                TextSpan(text: " "),
                TextSpan(text: AppLocalizations.of(context)!.and),
                TextSpan(text: " "),
                TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicy,
                  style: _themeController.captionMediumTextColor2nderlineTS,
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
