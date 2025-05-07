import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../constants_and_extensions/assets.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../global_controllers/in_app_subscription_controller.dart';
import '../../../global_controllers/loader_controller.dart';
import '../../../global_controllers/theme_controller.dart';
import '../../widgets/asset_image_widget.dart';
import '../../widgets/theme_elevated_button.dart';
import '../../widgets/world_map_image_widget.dart';
import '../connect_vpn_screen/connect_vpn_controller.dart';
import 'subscription_product_details.dart';

class InAppSubscriptionScreen extends StatelessWidget {
  InAppSubscriptionScreen({super.key});

  final ThemeController _themeController = Get.find();
  final InAppSubscriptionController _inAppSubscriptionController = Get.find();
  final LoaderController _loaderController = Get.find();
  final ConnectVpnController _connectVpnController = Get.find();

  @override
  Widget build(BuildContext context) {
    _inAppSubscriptionController.showLoaderForPurchaseInitiated.listen((val) {
      if (val) {
        _loaderController.showLoader();
      } else {
        _loaderController.hideLoader();
      }
    });
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _inAppSubscriptionController.isSubscriptionBought
                ? AppLocalizations.of(context)!.activeSubscription
                : AppLocalizations.of(context)!.upgradeToPremium,
            style: _themeController.title2BoldTS,
          ),
        ),
        body: (_inAppSubscriptionController.isLoading &&
                _inAppSubscriptionController.subscriptionProductList.isEmpty)
            ? Center(child: CircularProgressIndicator())
            : _inAppSubscriptionController.isSubscriptionBought
                ? _subscriptionBoughtWidget(
                    context: context,
                  )
                : _buySubscriptionWidget(
                    context: context,
                  ),
      );
    });
  }

  Widget _subscriptionBoughtWidget({
    required BuildContext context,
  }) {
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM d, yyyy').format(now);
    final subscribedProductDetails =
        _inAppSubscriptionController.getSubscribedProductDetails();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context)!.removeAdsAndUnlockAllLocation,
          style: _themeController.subheadlineRegularGrayTS,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 10,
            ),
            child: Container(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 12, left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment(0.9, 1),
                    colors: <Color>[
                      _themeController.darkBlue,
                      _themeController.pink
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  border: Border.all(
                    width: 1,
                    color: _themeController.borderColor,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: Text(
                              subscribedProductDetails?.productDetails.title ??
                                  "",
                              style: _themeController
                                  .title3BoldWhiteForAllModesTS),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _themeController.whiteColorForAllModes
                                .withValues(alpha: 0.35),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(AppLocalizations.of(context)!.currentPlan,
                              style: _themeController
                                  .captionBoldWhiteForAllModesTS),
                        ),
                      ],
                    ),
                    Text(
                      AppLocalizations.of(context)!.totalPrice(
                          subscribedProductDetails?.productDetails.price ?? ""),
                      style: _themeController.captionRegularWhiteForAllModesTS,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 4.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _themeController.whiteColorForAllModes
                              .withValues(alpha: 0.35),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!
                              .expiryDateWithColon(formattedDate),
                          textAlign: TextAlign.center,
                          style: _themeController.bodyBoldWhiteForAllModesTS,
                        ),
                      ),
                    ),
                  ],
                ))),
        // TextButton(
        //   onPressed: () {
        //     _inAppSubscriptionController.showLoaderForPurchaseInitiated
        //   },
        //   child: Text(
        //     AppLocalizations.of(context)!.cancelSubscription,
        //     style: _themeController.captionRegularGrayTS,
        //   ),
        // ),
      ],
    );
  }

  Widget _buySubscriptionWidget({
    required BuildContext context,
  }) {
    final benefits = [
      AppLocalizations.of(context)!.adsFree,
      AppLocalizations.of(context)!.hideIP,
      AppLocalizations.of(context)!.secure,
      AppLocalizations.of(context)!.faster,
    ];
    final subscriptionProductList =
        _inAppSubscriptionController.subscriptionProductList;
    final isAnyProductSelected =
        _inAppSubscriptionController.selectedProductID.isNotEmpty;

    final premiumBenefitsDimension = Get.height * 0.22;

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: WorldMapImageWidget(
            assetName: Assets().imageAssets.worldMapCurvedImage,
            height: Get.width * 0.8,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      AppLocalizations.of(context)!
                          .removeAdsAndUnlockAllLocation,
                      style: _themeController.subheadlineRegularGrayTS,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AssetImageWidget(
                        assetName: Assets().imageAssets.premiumBenefitsImage,
                        height: premiumBenefitsDimension,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        // width: Get.width * 0.7,
                        width: premiumBenefitsDimension * 1.5,
                        child: Column(
                          children: benefits
                              .asMap()
                              .entries
                              .map(
                                (entry) => _benefitItem(
                                  context: context,
                                  index: entry.key,
                                  title: entry.value,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (_inAppSubscriptionController.isLoading == false)
                Expanded(
                  child: subscriptionProductList.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .noProductsAvailableCurrenlty,
                            style: _themeController.bodyBoldTS,
                          ),
                        )
                      : Column(
                          children: [
                            Spacer(),
                            ListView.builder(
                              itemCount: subscriptionProductList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  _subscriptionPlanItem(
                                context: context,
                                index: index,
                                susbcriptionProductDetails:
                                    subscriptionProductList[index],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ThemeElevatedButton(
                                onPressed:
                                    !_connectVpnController.isVPNConnected &&
                                            isAnyProductSelected
                                        ? () {
                                            _inAppSubscriptionController
                                                .buySelectedProduct();
                                          }
                                        : null,
                                child: Text(
                                  AppLocalizations.of(context)!.getPremiumNow,
                                  style: isAnyProductSelected
                                      ? _themeController
                                          .subheadlineBoldWhiteForAllModesTS
                                      : _themeController.subheadlineBoldGrayTS,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _inAppSubscriptionController.restorePurchase();
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .restoreSubscription,
                                style: _themeController.captionRegularGrayTS,
                              ),
                            ),
                          ],
                        ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _benefitItem({
    required BuildContext context,
    required int index,
    required String title,
  }) {
    final item = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: _themeController.backgroundColor3,
        boxShadow: [
          BoxShadow(
            color: _themeController.shadowColor,
            spreadRadius: 5,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              color: _themeController.primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                Icons.check_rounded,
                size: 16,
                color: _themeController.whiteColorForAllModes,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 6,
            ),
            child: Text(
              title,
              style: _themeController.footnoteBoldTS,
            ),
          ),
        ],
      ),
    );

    final isEvenIndex = index % 2 == 0;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Row(
        children: [
          if (!isEvenIndex) Spacer(),
          index == 3
              ? Padding(padding: EdgeInsets.only(right: 40), child: item)
              : item,
          if (isEvenIndex) Spacer(),
        ],
      ),
    );
  }

  Widget _subscriptionPlanItem({
    required BuildContext context,
    required int index,
    required SubscriptionProductDetails susbcriptionProductDetails,
  }) {
    final double pricePerMonth;
    final productDetails = susbcriptionProductDetails.productDetails;
    final price = double.parse(productDetails.price ?? "");
    switch (susbcriptionProductDetails.inAppSubscriptionsEnum) {
      case InAppSubscriptionsEnum.monthly:
        pricePerMonth = price;
      case InAppSubscriptionsEnum.threeMonths:
        pricePerMonth = price / 3;
      case InAppSubscriptionsEnum.yearly:
        pricePerMonth = price / 12;
    }
    onTap() => _inAppSubscriptionController.setSelectedProduct(
        to: susbcriptionProductDetails);
    final item = Obx(() {
      final isSelected = _inAppSubscriptionController.selectedProductID ==
          productDetails.productId;
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => onTap(),
          child: Container(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: isSelected ? null : _themeController.backgroundColor3,
              gradient: isSelected
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.7, 1),
                      colors: <Color>[
                        _themeController.darkBlue,
                        _themeController.pink
                      ],
                      tileMode: TileMode.mirror,
                    )
                  : null,
              border: Border.all(
                width: 1,
                color: _themeController.borderColor,
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productDetails.title ?? "",
                      style: isSelected
                          ? _themeController.subheadlineBoldWhiteForAllModesTS
                          : _themeController.subheadlineBoldTS,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .totalPrice(productDetails.localizedPrice ?? ""),
                      style: isSelected
                          ? _themeController.captionRegularWhiteForAllModesTS
                          : _themeController.captionRegularGrayTS,
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${pricePerMonth.formatDouble(to: 2)}",
                      style: isSelected
                          ? _themeController.subheadlineBoldWhiteForAllModesTS
                          : _themeController.subheadlineBoldTS,
                    ),
                    Text(
                      AppLocalizations.of(context)!.forwardSlashMonth,
                      style: isSelected
                          ? _themeController.footnoteMediumWhiteForAllModesTS
                          : _themeController.footnoteRegularGrayTS,
                    ),
                  ],
                ),
                Radio(
                  value: productDetails.productId,
                  groupValue: _inAppSubscriptionController.selectedProductID,
                  fillColor: WidgetStateProperty.resolveWith(
                    (states) {
                      if (states.contains(WidgetState.selected)) {
                        return isSelected
                            ? _themeController.whiteColorForAllModes
                            : _themeController.textColor; // Selected color
                      }
                      return _themeController.gray; // Default color
                    },
                  ),
                  onChanged: (newValue) => onTap(),
                ),
              ],
            ),
          ),
        ),
      );
    });

    final mostPopular = InAppSubscriptionsEnum.monthly ==
        susbcriptionProductDetails.inAppSubscriptionsEnum;
    return !mostPopular
        ? item
        : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: item,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: <Color>[
                        _themeController.red,
                        _themeController.darkRed
                      ],
                      tileMode: TileMode.mirror,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.mostPopular,
                      style: _themeController.footnoteMediumWhiteForAllModesTS,
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
