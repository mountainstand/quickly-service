import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' show Get, GetNavigation, RxT;
import 'package:get/get_state_manager/get_state_manager.dart'
    show GetxController;
import 'package:google_fonts/google_fonts.dart';

import '../constants_and_extensions/app_colors.dart';
import '../constants_and_extensions/constants.dart';
import '../constants_and_extensions/shared_prefs.dart';

/// Initialised in [MyApp]
class ThemeController extends GetxController {
  //Shared Instance
  ThemeController._sharedInstance() : super() {
    addThemeObserver();
  }
  static final ThemeController _shared = ThemeController._sharedInstance();
  factory ThemeController() => _shared;

  // Reactive variable for the theme mode
  final themeMode = ThemeMode.system.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  Color get white => isDarkMode ? Colors.black : Colors.white;
  Color get black => isDarkMode ? Colors.white : Colors.black;

  Color get primaryColor => AppColors().primary;
  Color get screenBG => isDarkMode ? Colors.black : Colors.white;
  Color get whiteColorForAllModes => Colors.white;
  Color get blackColorForAllModes => Colors.black;
  Color get themeBasedWhiteColor => isDarkMode ? Colors.white : Colors.black;

  Color get backgroundColor =>
      isDarkMode ? AppColors().blackTwo : AppColors().whiteTwo;
  Color get backgroundColor2 =>
      isDarkMode ? AppColors().darkerGrey : Colors.white;
  Color get backgroundColor3 =>
      isDarkMode ? AppColors().blackThree : Colors.white;
  Color get backgroundColor4 => isDarkMode ? AppColors().gray : Colors.white;
  Color get backgroundColor5 => isDarkMode
      ? AppColors().blackThree
      : AppColors().primary.withValues(alpha: 0.3);

  Color get textColor => isDarkMode ? Colors.white : AppColors().blackThree;
  Color get textColor2 => isDarkMode ? Colors.white : AppColors().primary;
  Color get textColor3 => isDarkMode ? AppColors().blackThree : Colors.white;

  Color get iconColor => isDarkMode ? Colors.white : darkGray;
  Color get iconColor2 => isDarkMode ? Colors.white : AppColors().primary;

  Color get borderColor =>
      isDarkMode ? AppColors().borderColor : AppColors().lightGray;
  Color get activeBorderColor =>
      isDarkMode ? AppColors().primary : AppColors().whiteTwo;

  Color get buttonSelectedColor =>
      isDarkMode ? AppColors().primary : Colors.white;
  Color get buttonSelectedColor2 =>
      isDarkMode ? Colors.black : AppColors().primary;
  Color get buttonSelectedColor3 =>
      isDarkMode ? AppColors().blackThree : AppColors().lighterGray;

  Color get textFieldBGColor =>
      isDarkMode ? AppColors().blackThree : AppColors().lighterGray;

  Color get shadowColor => Colors.black12;
  Color get shadowColor2 => isDarkMode
      ? Colors.white.withValues(alpha: 0.3)
      : AppColors().primary.withValues(alpha: 0.3);

  Color get gray => AppColors().gray;
  Color get darkGray => AppColors().darkGray;
  Color get orange => AppColors().orange;

  Color get lightGreen => AppColors().lightGreen;
  Color get green => AppColors().green;
  Color get darkGreen => AppColors().darkGreen;

  Color get lightRed => AppColors().lightRed;
  Color get red => AppColors().red;
  Color get darkRed => AppColors().darkRed;

  Color get pink => AppColors().pink;
  Color get darkBlue => AppColors().darkBlue;

  Color get yellow => AppColors().yellow;

  // Method to toggle theme
  ThemeData getThemeData() {
    final Brightness brightness;
    final sharedPrefsTheme = SharedPrefs().getString(
          fromKey: SharedPrefsKeys.theme,
        ) ??
        "";
    if (sharedPrefsTheme.isNotEmpty) {
      if (sharedPrefsTheme == ThemeMode.dark.toString()) {
        brightness = Brightness.dark;
      } else {
        brightness = Brightness.light;
      }
    } else {
      brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
    switch (brightness) {
      case Brightness.dark:
        themeMode.value = ThemeMode.dark;
        break;
      case Brightness.light:
        themeMode.value = ThemeMode.light;
        break;
    }

    final colorSeed = ColorScheme.fromSeed(
        seedColor: primaryColor, // Customize the base color
        brightness: brightness);

    final Brightness statusBarBrightness;

    if (Platform.isAndroid) {
      // for android statusBarBrightness is reversed
      statusBarBrightness =
          brightness == Brightness.light ? Brightness.dark : Brightness.light;
    } else {
      statusBarBrightness = brightness;
    }

    final appBarTheme = AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Transparent status bar
          statusBarIconBrightness: statusBarBrightness,
          statusBarBrightness: brightness,
        ));

    final bottomNavigationBarThemeData = BottomNavigationBarThemeData(
      type: Platform.isIOS
          ? BottomNavigationBarType.fixed
          : BottomNavigationBarType.shifting,
      backgroundColor: backgroundColor,
      selectedItemColor: textColor,
      unselectedItemColor: gray,
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        disabledBackgroundColor: backgroundColor,
        foregroundColor: textColor,
        shadowColor: Colors.transparent,
      ),
    );

    final radioThemeData = RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return themeBasedWhiteColor; // Selected color
          }
          return gray; // Default color
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith(
          (states) => Colors.blue.withValues(alpha: 0.1)), // Ripple effect
    );

    final switchTheme = SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors().whiteTwo;
        }
        return gray;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return borderColor;
      }), // Track color
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return null;
        }
        return gray;
      }),
    );

    final checkBoxTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3), // Rounded corners
      ),
      fillColor: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor; // Color when checked
          }
          return Colors.transparent; // Default color when unchecked
        },
      ),
      side: BorderSide(color: gray, width: 1),
      checkColor: WidgetStateProperty.all(whiteColorForAllModes),
    );

    final ThemeData lightTheme = ThemeData(
      brightness: brightness,
      colorScheme: colorSeed,
      scaffoldBackgroundColor: screenBG,
      appBarTheme: appBarTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
      radioTheme: radioThemeData,
      switchTheme: switchTheme,
      checkboxTheme: checkBoxTheme,
    );

    final darkTheme = ThemeData(
      brightness: brightness,
      colorScheme: colorSeed,
      scaffoldBackgroundColor: screenBG,
      appBarTheme: appBarTheme,
      elevatedButtonTheme: elevatedButtonTheme,
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
      radioTheme: radioThemeData,
      switchTheme: switchTheme,
      checkboxTheme: checkBoxTheme,
    );

    removeThemeObserver();
    addThemeObserver();

    if (isDarkMode) {
      Get.changeTheme(darkTheme);
      return darkTheme;
    } else {
      Get.changeTheme(lightTheme);
      return lightTheme;
    }
  }

  void addThemeObserver() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;

      switch (brightness) {
        case Brightness.dark:
          themeMode.value = ThemeMode.dark;
          break;
        case Brightness.light:
          themeMode.value = ThemeMode.light;
          break;
      }
    };
  }

  void removeThemeObserver() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        null;
  }

  void toggleTheme() {
    if (isDarkMode) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
    SharedPrefs().setString(
      value: themeMode.value.toString(),
      inKey: SharedPrefsKeys.theme,
    );
  }

  //Text Themes
  TextStyle get extraLargeTitleBoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get largeTitleBoldPrimaryTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: primaryColor,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get titleBoldPrimaryTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: primaryColor,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get title2BoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get title2BoldWhiteForAllModesTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: whiteColorForAllModes,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get title3BoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get title3BoldTextColor2TS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor2,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get title3BoldPrimaryTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: primaryColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get title3BoldWhiteForAllModesTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: whiteColorForAllModes,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get headlineRegularTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 20,
      ));

  TextStyle get headlineMediumTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get headlineBoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get subheadlineBoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get subheadlineBoldWhiteForAllModesTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: whiteColorForAllModes,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get subheadlineBoldRedTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: red,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get subheadlineBoldGrayTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: gray,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get subheadlineRegularGrayTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: gray,
        fontSize: 18,
      ));

  TextStyle get subheadlineRegularTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 18,
      ));

  TextStyle get bodyBoldWhiteForAllModesTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: whiteColorForAllModes,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get bodyBoldBlackForAllModesTS => GoogleFonts.figtree(
      textStyle: TextStyle(
          color: blackColorForAllModes,
          fontSize: 17,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.none));

  TextStyle get bodyBoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get bodyMediumTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get bodyMediumUnderlineTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ));

  TextStyle get bodyMediumGrayTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: gray,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get bodyRegularTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 17,
      ));

  TextStyle get bodyRegularGrayTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: gray,
        fontSize: 17,
      ));

  TextStyle get captionMediumTextColor2nderlineTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor2,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
      ));

  TextStyle get captionRegularTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 15,
      ));

  TextStyle get captionRegularWhiteForAllModesTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: whiteColorForAllModes,
        fontSize: 15,
      ));

  TextStyle get captionRegularGrayTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: gray,
        fontSize: 15,
      ));

  TextStyle get captionMediumTextColor2TS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor2,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get captionMediumTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get captionMediumDarkGreenTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: darkGreen,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get captionMediumDarkRedTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: darkRed,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get captionBoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get captionBoldWhiteForAllModesTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: whiteColorForAllModes,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get footnoteRegularTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 13,
      ));

  TextStyle get footnoteRegularGrayTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: gray,
        fontSize: 13,
      ));

  TextStyle get footnoteMediumWhiteForAllModesTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: whiteColorForAllModes,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get footnoteMediumGrayTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: gray,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get footnoteBoldTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ));

  TextStyle get calloutMediumTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ));

  TextStyle get calloutRegularTS => GoogleFonts.figtree(
          textStyle: TextStyle(
        color: textColor,
        fontSize: 12,
      ));
}
