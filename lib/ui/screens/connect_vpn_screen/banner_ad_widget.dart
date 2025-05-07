import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../global_controllers/google_ads_controller.dart';
import '../../../global_controllers/in_app_subscription_controller.dart';

class BannerAdWidget extends StatelessWidget {
  BannerAdWidget({super.key});

  final GoogleAdsController _googleAdsController = Get.find();
  final InAppSubscriptionController _inAppSubscriptionController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (_inAppSubscriptionController.isSubscriptionBought) {
      _googleAdsController.deleteBannerAd();
    } else if (_googleAdsController.bannerAd == null) {
      _googleAdsController.loadBannerAd();
    }
    return SafeArea(
      child: SizedBox(
        width: _googleAdsController.bannerAd?.size.width.toDouble(),
        height: _googleAdsController.bannerAd?.size.height.toDouble(),
        child: (_googleAdsController.bannerAd == null)
            ? SizedBox()
            : AdWidget(ad: _googleAdsController.bannerAd!),
      ),
    );
  }
}
