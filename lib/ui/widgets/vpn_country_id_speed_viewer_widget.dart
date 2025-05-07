import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart' show Get, Inst;

import '../../api_services/models/server_list_response.dart';
import '../../constants_and_extensions/assets.dart';
import '../../constants_and_extensions/nonui_extensions.dart';
import '../../global_controllers/theme_controller.dart';
import '../screens/connect_vpn_screen/connect_vpn_controller.dart';
import 'app_network_image.dart';
import 'asset_image_widget.dart';
import 'circle_widget.dart';

class VpnCountryIdSpeedViewerWidget extends StatelessWidget {
  final ServerDetailsModel? serverDetailsModel;
  final bool showSpeedView;
  final double? downloadSpeed;
  final double? uploadSpeed;

  VpnCountryIdSpeedViewerWidget(
      {super.key,
      required this.serverDetailsModel,
      required this.showSpeedView,
      this.downloadSpeed,
      this.uploadSpeed})
      : assert(
          !showSpeedView || (downloadSpeed != null && uploadSpeed != null),
          'When showSpeedView is true, both downloadSpeed and uploadSpeed must be provided.',
        );

  final ThemeController _themeController = Get.find();
  final ConnectVpnController _connectVPNController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: _themeController.borderColor,
          ),
          borderRadius: BorderRadius.circular(16),
          color: _themeController.backgroundColor2,
          boxShadow: [
            BoxShadow(
              color: _themeController.shadowColor,
              spreadRadius: 2,
              blurRadius: 6,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleWidget(
                    size: 30,
                    child: AppNetworkImage(
                        imageURL: serverDetailsModel?.image ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          serverDetailsModel?.name ?? "",
                          style: _themeController.captionMediumTS,
                        ),
                        Text(
                          AppLocalizations.of(context)!.yourIP(
                              _connectVPNController.fetchingIP
                                  ? AppLocalizations.of(context)!
                                      .retrievingWithThreeDots
                                  : _connectVPNController.ipAddress),
                          style: _themeController.captionRegularGrayTS,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  // Icon(
                  //   Icons.chevron_right_rounded,
                  //   color: _themeController.textColor,
                  //   size: 28,
                  // ),
                ],
              ),
              if (showSpeedView) speedViewWidget(context: context)
            ],
          ),
        ));
  }

  Widget speedViewWidget({required BuildContext context}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Divider(
            color: _themeController.gray,
          ),
        ),
        Row(
          children: [
            _showSpeed(
              imageAsset: Assets().imageAssets.downloadIcon,
              imageColor: _themeController.orange,
              title: AppLocalizations.of(context)!.download,
              speed: downloadSpeed?.formatDouble(to: 2) ?? 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                color: _themeController.gray,
                width: 1,
                height: 20,
              ),
            ),
            _showSpeed(
              imageAsset: Assets().imageAssets.uploadIcon,
              imageColor: _themeController.green,
              title: AppLocalizations.of(context)!.upload,
              speed: uploadSpeed?.formatDouble(to: 2) ?? 0,
            ),
          ],
        )
      ],
    );
  }

  Widget _showSpeed({
    required String imageAsset,
    required Color imageColor,
    required String title,
    required double speed,
  }) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AssetImageWidget(
              assetName: imageAsset,
              width: 20,
              height: 20,
              color: imageColor,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _themeController.calloutMediumTS,
                ),
                Text(
                  "$speed Mbps",
                  style: _themeController.subheadlineBoldTS,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
