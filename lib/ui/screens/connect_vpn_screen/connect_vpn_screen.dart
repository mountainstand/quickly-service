import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart' show Get, Inst, GetNavigation, Obx;

import '../../../constants_and_extensions/assets.dart';
import '../../../global_controllers/google_ads_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/app_bar_icon_widget.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/asset_image_widget.dart';
import '../../widgets/circle_widget.dart';
import '../../widgets/vpn_country_id_speed_viewer_widget.dart';
import '../../widgets/world_map_image_widget.dart';
import '../server_locations_screen/server_locations_screen.dart';
import '../vpn_protocol_list_screen/vpn_protocol_list_screen.dart';
import 'banner_ad_widget.dart';
import 'connect_vpn_controller.dart';
import 'vpn_button.dart';

class ConnectVPNScreen extends StatelessWidget {
  ConnectVPNScreen({super.key});

  final _connectVPNController = Get.put(ConnectVpnController());
  final ThemeController _themeController = Get.find();
  final GoogleAdsController _googleAdsController = Get.find();
  final animationDuration = 500;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocalizations.of(context)!.appName,
            style: _themeController.title2BoldTS,
          ),
          actions: [
            Opacity(
              opacity: _connectVPNController.isVPNConnected ? 0.5 : 1,
              child: GestureDetector(
                onTap: _connectVPNController.isVPNConnected
                    ? null
                    : () {
                        if (!_connectVPNController.isVPNConnected) {
                          Get.to(() => VPNProtocolListScreen());
                        }
                      },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _themeController.borderColor,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: _themeController.backgroundColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        _connectVPNController.selectedVPNProtocol
                            .title(context: context),
                        style: _themeController.captionMediumTS,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: _themeController.textColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _serverIcon()
          ],
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: WorldMapImageWidget(
                assetName: Assets().imageAssets.worldMapImage,
                height: Get.width * 0.8,
              ),
            ),
            Positioned(
              top: Get.width * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _connectVPNController.isVPNConnected
                        ? AppLocalizations.of(context)!.connectedTime
                        : AppLocalizations.of(context)!.yourIP(
                            _connectVPNController.fetchingIP
                                ? AppLocalizations.of(context)!
                                    .retrievingWithThreeDots
                                : _connectVPNController.ipAddress),
                    style: _themeController.headlineMediumTS,
                  ),
                  _connectVPNController.isVPNConnected
                      ? Text(
                          _connectVPNController.vpnConnectedTimeToShow,
                          style: _themeController.extraLargeTitleBoldTS,
                        )
                      : Text(
                          AppLocalizations.of(context)!.tapToConnect,
                          style: _themeController.largeTitleBoldPrimaryTS,
                        ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: AnimatedVPNButton(
                animationDuration: animationDuration,
                isVPNConnected: _connectVPNController.isVPNConnected,
                themeMode: _themeController.themeMode.value,
                toggleConnection: () => _connectVPNController.toggleConnection(
                  appName: AppLocalizations.of(context)!.appName,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                  opacity: _googleAdsController.bannerAdIsLoaded &&
                          !_connectVPNController.isVPNConnected
                      ? 1.0
                      : 0.0,
                  duration: Duration(milliseconds: animationDuration),
                  child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: BannerAdWidget())),
            ),
            AnimatedOpacity(
                opacity: _connectVPNController.isVPNConnected ? 1.0 : 0.0,
                duration: Duration(milliseconds: animationDuration),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: VpnCountryIdSpeedViewerWidget(
                      showSpeedView: false,
                      serverDetailsModel:
                          _connectVPNController.selectedServerDetails,
                    ),
                  ),
                ))
          ],
        ),
      );
    });
  }

  Widget _serverIcon() {
    final isServerSelected = _connectVPNController.isServerSelected;
    final double iconSize;
    final double internalPadding;
    if (isServerSelected) {
      iconSize = 28;
      internalPadding = 6;
    } else {
      iconSize = 20;
      internalPadding = 10;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: AppBarIconWidget(
        iconSize: iconSize,
        internalPadding: internalPadding,
        onPressed: _connectVPNController.isVPNConnected
            ? null
            : () {
                if (!_connectVPNController.isVPNConnected) {
                  Get.to(() => ServerLocationsScreen());
                }
              },
        child: isServerSelected
            ? CircleWidget(
                size: 20 + 5,
                child: AppNetworkImage(
                  imageURL:
                      _connectVPNController.selectedServerDetails.image ?? "",
                ),
              )
            : AssetImageWidget(
                assetName: Assets().imageAssets.serverListIcon,
                color: _themeController.iconColor,
              ),
      ),
    );
  }
}
