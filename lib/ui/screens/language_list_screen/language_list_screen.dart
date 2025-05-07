import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../global_controllers/languages_controller.dart';
import '../../../global_controllers/theme_controller.dart';

class LanguageListScreen extends StatelessWidget {
  LanguageListScreen({super.key});

  final LanguagesController _languagesController = Get.find();
  final ThemeController _themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocalizations.of(context)!.selectLanguage,
            style: _themeController.headlineBoldTS,
          ),
        ),
        body: ListView.builder(
          itemCount: _languagesController.locales.length,
          itemBuilder: (context, index) => _vpnProtocolItem(
              context: context,
              index: index,
              locale: _languagesController.locales[index]),
        ),
      );
    });
  }

  Widget _vpnProtocolItem({
    required BuildContext context,
    required int index,
    required Locale locale,
  }) {
    void onPressed(newValue) {
      _languagesController.updateLocale(locale: locale);
      Get.back();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: GestureDetector(
        onTap: () => onPressed(locale),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: _themeController.backgroundColor3,
            boxShadow: [
              BoxShadow(
                color: _themeController.shadowColor,
                spreadRadius: 2,
                blurRadius: 6,
              )
            ],
          ),
          child: Row(
            children: [
              Text(
                locale.languageCode.toUpperCase(),
                style: _themeController.bodyBoldTS,
              ),
              Spacer(),
              Radio(
                value: locale,
                groupValue: _languagesController.currentLocale,
                onChanged: (newValue) => onPressed(newValue),
              )
            ],
          ),
        ),
      ),
    );
  }
}
