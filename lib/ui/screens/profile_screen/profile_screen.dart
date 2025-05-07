import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../constants_and_extensions/assets.dart';
import '../../../constants_and_extensions/flutter_toast_manager.dart';
import '../../../global_controllers/in_app_subscription_controller.dart';
import '../../../global_controllers/loader_controller.dart';
import '../../../global_controllers/login_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';
import '../../widgets/theme_elevated_button.dart';
import '../bottom_navigation_bar/bottom_navigation_controller.dart';
import '../connect_vpn_screen/connect_vpn_controller.dart';
import 'profile_screen_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ThemeController _themeController = Get.find();
  final ConnectVpnController _connectVPNController = Get.find();
  final LoginController _loginController = Get.find();
  final InAppSubscriptionController _inAppSubscriptionController = Get.find();
  final BottomNavigationController _bottomNavigationController = Get.find();
  final ProfileScreenController _profileController =
      Get.put(ProfileScreenController());
  final LoaderController _loaderController = Get.find();

  @override
  Widget build(BuildContext context) {
    _profileController.getUserDetails();
    final double verticalPadding = 5;
    final double horizontalPadding = verticalPadding * 3;
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: _themeController.headlineBoldTS,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              if ((_profileController.userDetails.email ?? "").isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: verticalPadding),
                  child: Card(
                    color: _themeController.backgroundColor3,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: verticalPadding * 2,
                                  bottom: verticalPadding,
                                  left: horizontalPadding,
                                  right: horizontalPadding,
                                ),
                                child: Text(
                                  _profileController.userDetails.email ?? "",
                                  style: _themeController.headlineBoldTS,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: verticalPadding * 2,
                                  left: horizontalPadding,
                                  right: horizontalPadding,
                                ),
                                child: Text(
                                  _profileController.userDetails.email ?? "",
                                  style: _themeController.bodyRegularGrayTS,
                                ),
                              )
                            ],
                          ),
                        ),
                        //edit button
                      ],
                    ),
                  ),
                ),
              Card(
                color: _themeController.backgroundColor3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_loginController.currentUserDetails?.uid != null)
                      _listTile(
                        withName: AppLocalizations.of(context)!.userIDWithColon,
                        trailingWidget: _showValueText(
                          value: _loginController.currentUserDetails!.uid,
                        ),
                        padding: EdgeInsets.only(
                          top: verticalPadding * 2,
                          bottom: verticalPadding,
                          left: horizontalPadding,
                          right: horizontalPadding,
                        ),
                      ),
                    _listTile(
                      withName: AppLocalizations.of(context)!.myIPWithColon,
                      trailingWidget: _showValueText(
                        value: _connectVPNController.ipAddress,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding,
                      ),
                    ),
                    _listTile(
                      withName: AppLocalizations.of(context)!.typeWithColon,
                      trailingWidget:
                          _subscriptionStatusWidget(context: context),
                      padding: EdgeInsets.only(
                        top: verticalPadding,
                        bottom: verticalPadding * 2,
                        left: horizontalPadding,
                        right: horizontalPadding,
                      ),
                    ),
                    _listTile(
                      withName: AppLocalizations.of(context)!.logInVia,
                      trailingWidget: _showValueText(
                        value: _connectVPNController.ipAddress,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: verticalPadding,
                        horizontal: horizontalPadding,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              if (!_inAppSubscriptionController.isSubscriptionBought)
                ThemeElevatedButton(
                  onPressed: () {
                    Get.back();
                    _bottomNavigationController
                        .updateIndex(BottomBarEnum.subscriptionPlan);
                  },
                  child: Text(AppLocalizations.of(context)!.getPremiumNow,
                      style:
                          _themeController.subheadlineBoldWhiteForAllModesTS),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ThemeElevatedButton(
                  backgroundColor: _themeController.backgroundColor,
                  onPressed: () async {
                    // _loaderController.showLoader();
                    final result = await _loginController.signOut();
                    // _loaderController.hideLoader();
                    if (result.success) {
                      Get.back();
                    }
                    FlutterToastManager().showToast(
                      withMessage: result.message,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AssetImageWidget(
                        assetName: Assets().imageAssets.signOutIcon,
                        width: 25,
                        height: 25,
                        color: _themeController.themeBasedWhiteColor,
                      ),
                      Text(AppLocalizations.of(context)!.signOut,
                          style: _themeController.subheadlineBoldTS),
                    ],
                  ),
                ),
              ),
              ThemeElevatedButton(
                backgroundColor: _themeController.backgroundColor,
                onPressed: () async {
                  _loaderController.showLoader();
                  final result = await _loginController.deleteAccount();
                  _loaderController.hideLoader();
                  if (result.success) {
                    Get.back();
                  }
                  FlutterToastManager().showToast(
                    withMessage: result.message,
                  );
                },
                child: Text(AppLocalizations.of(context)!.deleteAccount,
                    style: _themeController.subheadlineBoldRedTS),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _listTile({
    required String withName,
    required Widget trailingWidget,
    required EdgeInsetsGeometry padding,
  }) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(
            withName,
            style: _themeController.subheadlineRegularGrayTS,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: trailingWidget,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showValueText({required String value}) {
    return Text(
      value,
      style: _themeController.subheadlineRegularTS,
      textAlign: TextAlign.end,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _subscriptionStatusWidget({required BuildContext context}) {
    final isSubscriptionBought =
        _inAppSubscriptionController.isSubscriptionBought;
    final text = isSubscriptionBought
        ? AppLocalizations.of(context)!.premiumAllCaps
        : AppLocalizations.of(context)!.freeAllCaps;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isSubscriptionBought ? null : _themeController.green,
        gradient: isSubscriptionBought
            ? LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment(0.9, 1),
                colors: <Color>[
                  _themeController.darkBlue,
                  _themeController.pink
                ],
                tileMode: TileMode.mirror,
              )
            : null,
      ),
      child: Text(
        text,
        style: _themeController.captionRegularWhiteForAllModesTS,
      ),
    );
  }
}
