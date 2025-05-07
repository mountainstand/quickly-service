import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../global_controllers/login_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../language_list_screen/language_list_screen.dart';
import '../login/login_screen.dart';
import 'menu_model.dart';
import 'menu_screen_controller.dart';
import '../profile_screen/profile_screen.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({super.key});

  final ThemeController _themeController = Get.find();
  final LoginController _loginController = Get.find();
  final MenuScreenController _menuController = Get.put(MenuScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final menuItems = _menuController.getMenuItems(
        context: context,
        isUserLoggedIn: _loginController.isUserLoggedIn,
      );
      _menuController.checkPushNotificationPermission();
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocalizations.of(context)!.menu,
            style: _themeController.title2BoldTS,
          ),
        ),
        body: ListView.builder(
          itemCount: menuItems.length,
          itemBuilder: (context, index) => _settingItem(
            context: context,
            index: index,
            menuModel: menuItems[index],
          ),
        ),
      );
    });
  }

  Widget _settingItem({
    required BuildContext context,
    required int index,
    required MenuModel menuModel,
  }) {
    final settingItem = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 20,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuModel.title,
                  style: _themeController.bodyMediumTS,
                ),
              ],
            ),
            Spacer(),
            menuModel.showSwitch
                ? Switch(
                    value: menuModel.switchValue,
                    onChanged: (bool value) {
                      switch (menuModel.menuItemEnum) {
                        case MenuItemEnum.notificationPermission:
                          _menuController.togglePushNotificationPermission(
                            context: context,
                            value: value,
                          );
                          break;
                        case MenuItemEnum.theme:
                          _themeController.toggleTheme();
                          break;
                        default:
                          break;
                      }
                    },
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Text(
                          menuModel.stringValue,
                          style: _themeController.captionMediumTS,
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: _themeController.textColor,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
    switch (menuModel.menuItemEnum) {
      case MenuItemEnum.notificationPermission:
      case MenuItemEnum.theme:
        return settingItem;
      case MenuItemEnum.lanugage:
        return InkWell(
          onTap: () => Get.to(() => LanguageListScreen()),
          child: settingItem,
        );
      case MenuItemEnum.login:
        return InkWell(
          onTap: () => Get.to(() => LoginScreen()),
          child: settingItem,
        );
      case MenuItemEnum.profile:
        return InkWell(
          onTap: () => Get.to(() => ProfileScreen()),
          child: settingItem,
        );
    }
  }
}
