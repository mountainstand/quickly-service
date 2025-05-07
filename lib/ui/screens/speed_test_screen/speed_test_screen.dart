import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../constants_and_extensions/assets.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../global_controllers/speed_test_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/app_bar_icon_widget.dart';
import '../../widgets/asset_image_widget.dart';
import '../../widgets/theme_elevated_button.dart';
import '../../widgets/vpn_country_id_speed_viewer_widget.dart';
import '../../widgets/world_map_image_widget.dart';
import '../connect_vpn_screen/connect_vpn_controller.dart';
import '../speed_compare_screen/speed_compare_screen.dart';
import 'speed_progrees_view.dart';

class SpeedTestScreen extends StatelessWidget {
  SpeedTestScreen({super.key});

  final ThemeController _themeController = Get.find();
  final appBarIconSize = 20.0;

  final SpeedTestController _speedTestController = Get.find();
  final ConnectVpnController _connectVpnController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // final hasRunSpeedTestOnce = false;
      final hasRunSpeedTestOnce =
          _speedTestController.internetSpeedModel.downloadResult != null &&
              _speedTestController.internetSpeedModel.uploadResult != null;
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocalizations.of(context)!.speed,
            style: _themeController.title2BoldTS,
          ),
          actions: hasRunSpeedTestOnce &&
                  _speedTestController.isRunningSpeedTest == false
              ? [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                    ),
                    child: AppBarIconWidget(
                      iconSize: appBarIconSize,
                      onPressed: () => Get.to(() => SpeedCompareScreen()),
                      child: AssetImageWidget(
                        assetName: Assets().imageAssets.speedTestHistoryIcon,
                        color: _themeController.iconColor,
                      ),
                    ),
                  ),
                ]
              : null,
        ),
        body: Stack(
          children: [
            SizedBox(
              height: Get.height * 0.5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: WorldMapImageWidget(
                      assetName: Assets().imageAssets.worldMapImage,
                      height: Get.width * 0.8,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SpeedProgreesView(
                        speed: (_speedTestController.speedToShow)
                            .formatDouble(to: 2)),
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Spacer(),
                        if (hasRunSpeedTestOnce &&
                            _speedTestController.isRunningDownloadTest == false)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: VpnCountryIdSpeedViewerWidget(
                              serverDetailsModel: _connectVpnController
                                      .isVPNConnected
                                  ? _connectVpnController.selectedServerDetails
                                  : _connectVpnController.selectedServerDetails,
                              showSpeedView: true,
                              downloadSpeed: _speedTestController
                                      .internetSpeedModel
                                      .downloadResult
                                      ?.transferRate ??
                                  0,
                              uploadSpeed: _speedTestController
                                      .internetSpeedModel
                                      .uploadResult
                                      ?.transferRate ??
                                  0,
                            ),
                          ),
                        ThemeElevatedButton(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            onPressed: _speedTestController.isRunningSpeedTest
                                ? null
                                : () {
                                    _speedTestController.getIPDetails(
                                      isVPNConnected:
                                          _connectVpnController.isVPNConnected,
                                    );
                                  },
                            child: Text(
                              _speedTestController.isRunningSpeedTest
                                  ? AppLocalizations.of(context)!
                                      .processingWithThreeDots
                                  : hasRunSpeedTestOnce
                                      ? AppLocalizations.of(context)!.testAgain
                                      : AppLocalizations.of(context)!.testSpeed,
                              style: _speedTestController.isRunningSpeedTest
                                  ? _themeController.subheadlineBoldGrayTS
                                  : _themeController
                                      .subheadlineBoldWhiteForAllModesTS,
                            )),
                      ],
                    ))),
          ],
        ),
      );
    });
  }
}
