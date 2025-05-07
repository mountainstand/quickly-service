import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Initialised in [MyApp]
class LanguagesController extends GetxController {
  final delegates = AppLocalizations.localizationsDelegates;
  final locales = AppLocalizations.supportedLocales;

  final _locale = (Get.locale ?? Locale('en')).obs; // Default locale
  Locale get currentLocale => _locale.value; // Default locale

  void updateLocale({required Locale locale}) {
    _locale.value = locale;
    Get.updateLocale(_locale.value);
  }
}
