import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../constants_and_extensions/push_notification_manager.dart';
import '../../../global_controllers/languages_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import 'menu_model.dart';

enum MenuItemEnum { login, profile, notificationPermission, theme, lanugage }

/// Initialised in [MenuScreen]
class MenuScreenController extends GetxController {
  MenuScreenController() {
    checkPushNotificationPermission();
  }

  final _isPushNotificationEnabled = false.obs;
  final ThemeController _themeController = Get.find();
  final LanguagesController _languagesController = Get.find();

  List<MenuModel> getMenuItems({
    required BuildContext context,
    required bool isUserLoggedIn,
  }) {
    return [
      isUserLoggedIn
          ? MenuModel(
              menuItemEnum: MenuItemEnum.profile,
              title: AppLocalizations.of(context)!.profile,
              showSwitch: false,
            )
          : MenuModel(
              menuItemEnum: MenuItemEnum.login,
              title: AppLocalizations.of(context)!.login,
              showSwitch: false,
            ),
      MenuModel(
        menuItemEnum: MenuItemEnum.notificationPermission,
        title: AppLocalizations.of(context)!.notifications,
        showSwitch: true,
        switchValue: _isPushNotificationEnabled.value,
      ),
      MenuModel(
        menuItemEnum: MenuItemEnum.theme,
        title: AppLocalizations.of(context)!.darkTheme,
        showSwitch: true,
        switchValue: _themeController.isDarkMode,
      ),
      MenuModel(
        menuItemEnum: MenuItemEnum.lanugage,
        title: AppLocalizations.of(context)!.language,
        showSwitch: false,
        stringValue:
            _languagesController.currentLocale.languageCode.toUpperCase(),
      ),
    ];
  }

  Future<void> checkPushNotificationPermission() async {
    final permissionStatus =
        await PushNotificationsManager().getNotificationSettings;
    ("permissionStatus in _checkPushNotificationPermission", permissionStatus)
        .log();
    _isPushNotificationEnabled.value =
        permissionStatus.authorizationStatus.isGranted;
  }

  // Toggle the push notification permission status
  Future<void> togglePushNotificationPermission({
    required BuildContext context,
    required bool value,
  }) async {
    if (value) {
      final status = await PushNotificationsManager().getNotificationSettings;
      status.log();
      switch (status.authorizationStatus) {
        case AuthorizationStatus.authorized:
        case AuthorizationStatus.provisional:
          break;
        case AuthorizationStatus.denied:
          await openAppSettings();
          break;
        case AuthorizationStatus.notDetermined:
          await PushNotificationsManager().requestNotificationPermission;
          break;
      }
    } else {
      // The user has turned off push notifications, handle the case if necessary
      // (e.g., you can show a dialog to ask the user to enable it)
      await openAppSettings();
    }
    // Update the UI based on the new status
    checkPushNotificationPermission();
  }
}
