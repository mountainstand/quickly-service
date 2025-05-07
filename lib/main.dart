import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' show Get, Inst, Obx, GetMaterialApp;
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'constants_and_extensions/constants.dart';
import 'constants_and_extensions/internet_connectivity.dart';
import 'constants_and_extensions/nonui_extensions.dart';
import 'constants_and_extensions/push_notification_manager.dart';
import 'constants_and_extensions/shared_prefs.dart';
import 'firebase_options.dart';
import 'global_controllers/google_ads_controller.dart';
import 'global_controllers/in_app_subscription_controller.dart';
import 'global_controllers/languages_controller.dart';
import 'global_controllers/loader_controller.dart';
import 'global_controllers/login_controller.dart';
import 'global_controllers/network_controller.dart';
import 'global_controllers/theme_controller.dart';
import 'global_controllers/speed_test_controller.dart';
import 'ui/screens/bottom_navigation_bar/bottom_navigation_bar_screen.dart';

void main() {
  /// runZonedGuarded catches errors from async operations (e.g., Future, Timer, Stream).
  /// Prevents unhandled exceptions from crashing the app.
  /// Useful for logging fatal crashes in Firebase Crashlytics.
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    unawaited(MobileAds.instance.initialize());
    final List<Future<dynamic>> list = [
      SharedPrefs().initialiseSharePrefs(),
      Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform,
          ),
    ];
    await Future.wait(list);
    SharedPrefs().delete(fromKey: SharedPrefsKeys.speedBeforeVPN);
    SharedPrefs().delete(fromKey: SharedPrefsKeys.speedAfterVPN);
    // SharedPrefs().delete(fromKey: SharedPrefsKeys.purchaseDetails);

    // SharedPrefs().setJSON(value: {
    //   "download": "8032.68Mbps",
    //   "upload": "7023.28Mbps",
    //   "ping": 0.37,
    //   "isp": "Digital Ocean",
    //   "server": {
    //     "name": "Ubinet Wireless",
    //     "location": "San Sebastián, Puerto Rico"
    //   },
    //   "message": "success"
    // }, inKey: SharedPrefsKeys.speedBeforeVPN);
    // SharedPrefs().setJSON(value: {
    //   "download": "1632.68Mbps",
    //   "upload": "1423.28Mbps",
    //   "ping": 0.3017,
    //   "isp": "Digital Oceanfghfgh",
    //   "server": {
    //     "name": "Ubinet Wirelessfghfgh",
    //     "location": "San Sebastián, Puerto Rifghfghco"
    //   },
    // }, inKey: SharedPrefsKeys.speedAfterVPN);

    PushNotificationsManager();

    /// Non-async exceptions
    /// This captures Flutter framework errors (typically non-fatal).
    FlutterError.onError = (errorDetails) {
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(errorDetails);
        errorDetails.log();
        "PlatformDispatcher.instance.onError:".logWith(
          error: errorDetails.exception,
          stack: errorDetails.stack,
        );
      } else {
        // If you want to record a "non-fatal" exception
        // FirebaseCrashlytics.instance.recordFlutterError(
        //   errorDetails,
        // );
        // // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordFlutterFatalError(
          errorDetails,
        );
      }
    };

    /// This captures Dart (uncaught) errors and native crashes (potentially fatal).
    /// Synchronous errors (uncaught exceptions in Dart).
    /// Asynchronous errors (but only those outside of runZonedGuarded).
    /// Flutter and platform-level errors.
    /// Errors that crash the app (fatal errors).
    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        "PlatformDispatcher.instance.onError:".logWith(
          error: error,
          stack: stack,
        );
      } else {
        FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          fatal: true,
        );
      }
      return true;
    };
    runApp(MyApp());
  }, (error, stackTrace) {
    if (kDebugMode) {
      "RunZonedGuarded Error:".logWith(
        error: error,
        stack: stackTrace,
      );
    } else {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        fatal: true,
      );
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    InternetConnectivity();
    Get.lazyPut(() => NetworkController());
    final ThemeController themeController = Get.put(ThemeController());
    final LanguagesController languagesController =
        Get.put(LanguagesController());

    Get.lazyPut(() => GoogleAdsController());
    Get.lazyPut(() => LoaderController());

    Get.lazyPut(() => InAppSubscriptionController()
      ..getSubscriptions()
      ..checkPastPurchases());
    Get.lazyPut(() => SpeedTestController());
    Get.lazyPut(() => LoginController());

    return Obx(() {
      return GetMaterialApp(
        title: 'Quickly App',
        theme: themeController.getThemeData(),
        darkTheme: themeController.getThemeData(),
        locale: languagesController.currentLocale,
        localizationsDelegates: languagesController.delegates,
        supportedLocales: languagesController.locales,
        debugShowCheckedModeBanner: false,
        home: BottomNavigationBarScreen(),
      );
    });
  }
}
