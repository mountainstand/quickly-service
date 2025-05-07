import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../constants_and_extensions/assets.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';
import '../connect_vpn_screen/connect_vpn_screen.dart';
import '../in_app_subscription_screen/in_app_subscription_screen.dart';
import '../menu_screen/menu_screen.dart';
import '../speed_test_screen/speed_test_screen.dart';
import 'bottom_navigation_controller.dart';

class BottomNavigationBarScreen extends StatelessWidget {
  BottomNavigationBarScreen({super.key});

  final _bottomNavigationController = Get.put(BottomNavigationController());
  // final _networkController = Get.put(NetworkController());
  final ThemeController _themeController = Get.find();

  final List<Widget> screens = BottomBarEnum.values.map((e) {
    switch (e) {
      case BottomBarEnum.home:
        return ConnectVPNScreen();
      case BottomBarEnum.speedTest:
        return SpeedTestScreen();
      case BottomBarEnum.subscriptionPlan:
        return InAppSubscriptionScreen();
      case BottomBarEnum.menu:
        return MenuScreen();
    }
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // final hasInternetConnection = _networkController.hasInternetConnection;
      return Scaffold(
          body: screens[_bottomNavigationController.selectedIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: Platform.isIOS
                    ? Theme(
                        data: Theme.of(context).copyWith(
                          splashFactory:
                              NoSplash.splashFactory, // Disables ripple effect
                          highlightColor:
                              Colors.transparent, // Removes highlight effect
                        ),
                        child: _bottomNavigationBar(context: context))
                    : _bottomNavigationBar(context: context)),
          ));
    });
  }

  Widget _bottomNavigationBar({required BuildContext context}) {
    return BottomNavigationBar(
        currentIndex: _bottomNavigationController.selectedIndex,
        onTap: (index) {
          _bottomNavigationController.updateIndex(BottomBarEnum.values[index]);
        },
        // these 2 colors provided in theme_controller
        // selectedItemColor: _themeController.textColor,
        // unselectedItemColor: _themeController.gray,
        showSelectedLabels: true,
        // showUnselectedLabels: true,
        selectedLabelStyle: _themeController.footnoteBoldTS,
        unselectedLabelStyle: _themeController.footnoteRegularTS,
        items: BottomBarEnum.values.map((e) {
          return _bottomNavigationBarItem(context: context, bottomBarEnum: e);
        }).toList());
  }

  String getActiveIcon({required BottomBarEnum forTab}) {
    switch (forTab) {
      case BottomBarEnum.home:
        return Assets().imageAssets.homeFilledIcon;
      case BottomBarEnum.speedTest:
        return Assets().imageAssets.speedFilledTestIcon;
      case BottomBarEnum.subscriptionPlan:
        return Assets().imageAssets.inAppFilledPurchaseIcon;
      case BottomBarEnum.menu:
        return Assets().imageAssets.menuFilledIcon;
    }
  }

  String getInactiveIcon({required BottomBarEnum forTab}) {
    switch (forTab) {
      case BottomBarEnum.home:
        return Assets().imageAssets.homeIcon;
      case BottomBarEnum.speedTest:
        return Assets().imageAssets.speedTestIcon;
      case BottomBarEnum.subscriptionPlan:
        return Assets().imageAssets.inAppPurchaseIcon;
      case BottomBarEnum.menu:
        return Assets().imageAssets.menuIcon;
    }
  }

  String getLabel({
    required BuildContext context,
    required BottomBarEnum forTab,
  }) {
    switch (forTab) {
      case BottomBarEnum.home:
        return AppLocalizations.of(context)!.vpn;
      case BottomBarEnum.speedTest:
        return AppLocalizations.of(context)!.speed;
      case BottomBarEnum.subscriptionPlan:
        return AppLocalizations.of(context)!.upgrade;
      case BottomBarEnum.menu:
        return AppLocalizations.of(context)!.menu;
    }
  }

  BottomNavigationBarItem _bottomNavigationBarItem({
    required BottomBarEnum bottomBarEnum,
    required BuildContext context,
  }) {
    final iconSize = 24.0;
    return BottomNavigationBarItem(
        activeIcon: AssetImageWidget(
          assetName: getActiveIcon(forTab: bottomBarEnum),
          width: iconSize,
          height: iconSize,
          // colorFilter: ColorFilter.mode(
          //   _themeController.primaryColor,
          //   BlendMode.srcIn,
          // ),
        ),
        icon: AssetImageWidget(
          assetName: getInactiveIcon(forTab: bottomBarEnum),
          width: iconSize,
          height: iconSize,
        ),
        label: getLabel(context: context, forTab: bottomBarEnum));
  }

  // Widget _buildNoInternetConnection({
  //   required BuildContext context,
  // }) {
  //   return Container(
  //     color: _themeController.blackColorForAllModes
  //         .withValues(alpha: 0.5), // Semi-transparent background
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Container(
  //             padding: EdgeInsets.symmetric(
  //                 horizontal: 20, vertical: 10), // Padding inside the box
  //             decoration: BoxDecoration(
  //               color:
  //                   _themeController.whiteColorForAllModes, // White background
  //               borderRadius: BorderRadius.circular(10), // Rounded corners
  //             ),
  //             child: Text(
  //               "No Internet Connected",
  //               style: _themeController.bodyBoldBlackForAllModesTS,
  //             ),
  //             // Image.asset(
  //             //   Assets().gifAssets.loader,
  //             //   width: 100,
  //             //   height: 100,
  //             // ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
