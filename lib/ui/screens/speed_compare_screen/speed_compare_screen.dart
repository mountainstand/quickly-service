import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import '../../../constants_and_extensions/assets.dart';
import '../../../constants_and_extensions/ui_extensions.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';
import '../../widgets/theme_elevated_button.dart';
import 'internet_speed_compared_model.dart';
import 'speed_compare_controller.dart';

class SpeedCompareScreen extends StatelessWidget {
  SpeedCompareScreen({super.key});

  final _speedCompareController = Get.put(SpeedCompareController());

  final ThemeController _themeController = Get.find();
  final double spacingBetweenWidgets = 10;
  final double padding = 16;
  final double borderRadius = 10;
  List<BoxShadow> get boxShadow => [
        BoxShadow(
          color: _themeController.shadowColor,
          spreadRadius: 2,
          blurRadius: 6,
        )
      ];
  Color get backgroundColor => _themeController.backgroundColor3;

  @override
  Widget build(BuildContext context) {
    _speedCompareController.setData();
    return Obx(() {
      final hasVPNData = _speedCompareController.vpnSpeedModel != null;
      final hasBeforeVPNData = _speedCompareController.vpnSpeedModel != null;
      final hasBothSpeedData = hasVPNData && hasBeforeVPNData;
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            (hasBothSpeedData)
                ? AppLocalizations.of(context)!.speedCompare
                : AppLocalizations.of(context)!.speed,
            style: _themeController.title2BoldTS,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: spacingBetweenWidgets,
            horizontal: padding,
          ),
          child: Column(
            children: [
              if (hasBothSpeedData)
                Container(
                  margin: EdgeInsets.symmetric(vertical: spacingBetweenWidgets),
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius)),
                    color: backgroundColor,
                    boxShadow: boxShadow,
                  ),
                  child: Row(
                    children: [
                      _beforeAfterWidget(
                        context: context,
                        isBefore: true,
                      ),
                      _beforeAfterWidget(
                        context: context,
                        isBefore: false,
                      )
                    ].expandEqually().toList(),
                  ),
                ),
              _speedWidget(
                context: context,
                isDownload: true,
                hasVPNData: hasVPNData,
              ),
              _speedWidget(
                context: context,
                isDownload: false,
                hasVPNData: hasVPNData,
              ),
              // Container(
              //     margin: EdgeInsets.symmetric(vertical: spacingBetweenWidgets),
              //     padding: EdgeInsets.all(padding),
              //     decoration: BoxDecoration(
              //       borderRadius:
              //           BorderRadius.all(Radius.circular(borderRadius)),
              //       color: backgroundColor,
              //       boxShadow: boxShadow,
              //       border: Border.all(
              //         color: _themeController.borderColor,
              //       ),
              //     ),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         _extraDetails(
              //           title: AppLocalizations.of(context)!.ping,
              //           value:
              //               "${(_speedCompareController.selectedSpeedModel?.ping ?? 0).formatDouble(to: 2)} ms",
              //         ),
              //         _extraDetails(
              //           title: AppLocalizations.of(context)!.jitter,
              //           value:
              //               _speedCompareController.selectedSpeedModel?.isp ??
              //                   "",
              //         ),
              //         // _extraDetails(
              //         //   title: AppLocalizations.of(context)!.ping,
              //         //   value: "15 %",
              //         // )
              //       ],
              //     ))
            ],
          ),
        ),
      );
    });
  }

  Widget _beforeAfterWidget({
    required BuildContext context,
    required bool isBefore,
  }) {
    final bool isSelected;
    if (isBefore) {
      isSelected = isBefore && _speedCompareController.isBeforeSelected;
    } else {
      isSelected = !isBefore && !_speedCompareController.isBeforeSelected;
    }
    return Padding(
      padding: EdgeInsets.only(right: isBefore ? 6 : 0, left: isBefore ? 0 : 6),
      child: ThemeElevatedButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          _speedCompareController.setBeforeSelected(value: isBefore);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            color: isSelected ? _themeController.primaryColor : null,
            border: isSelected
                ? null
                : Border.all(
                    color: _themeController.borderColor,
                  ),
          ),
          child: Center(
            child: Text(
              isBefore
                  ? AppLocalizations.of(context)!.before
                  : AppLocalizations.of(context)!.after,
              style: isSelected
                  ? _themeController.bodyBoldWhiteForAllModesTS
                  : _themeController.bodyBoldTS,
            ),
          ),
        ),
      ),
    );
  }

  Widget _speedWidget({
    required BuildContext context,
    required bool isDownload,
    required bool hasVPNData,
  }) {
    final String imageAsset;
    final InternetSpeedComparedModel internetDetails;

    if (isDownload) {
      internetDetails = _speedCompareController.downloadInternetDetails;
      if (internetDetails.hasIncreased) {
        imageAsset = Assets().imageAssets.downloadUpwardGraph;
      } else {
        imageAsset = Assets().imageAssets.downloadDownwardGraph;
      }
    } else {
      internetDetails = _speedCompareController.uploadInternetDetails;
      if (internetDetails.hasIncreased) {
        imageAsset = Assets().imageAssets.uploadUpwardGraph;
      } else {
        imageAsset = Assets().imageAssets.uploadDownwardGraph;
      }
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: spacingBetweenWidgets),
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: backgroundColor,
        boxShadow: boxShadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isDownload
                ? AppLocalizations.of(context)!.download
                : AppLocalizations.of(context)!.upload,
            style: _themeController.captionBoldTS,
          ),
          if (hasVPNData)
            AssetImageWidget(
              assetName: imageAsset,
              color: internetDetails.hasIncreased
                  ? _themeController.green
                  : _themeController.orange,
            ),
          Text(
            internetDetails.speed,
            style: _themeController.captionMediumTS,
          ),
          if (hasVPNData)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 6,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: internetDetails.hasIncreased
                    ? _themeController.lightGreen
                    : _themeController.lightRed,
              ),
              child: Text(
                internetDetails.percentageDifference,
                style: internetDetails.hasIncreased
                    ? _themeController.captionMediumDarkGreenTS
                    : _themeController.captionMediumDarkRedTS,
              ),
            ),
        ],
      ),
    );
  }

  // Widget _extraDetails({
  //   required String title,
  //   required String value,
  // }) {
  //   return Column(
  //     children: [
  //       Text(
  //         title,
  //         style: _themeController.footnoteMediumGrayTS,
  //       ),
  //       Text(
  //         value,
  //         style: _themeController.subheadlineBoldTS,
  //       ),
  //     ],
  //   );
  // }
}
