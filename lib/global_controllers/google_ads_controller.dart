import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants_and_extensions/nonui_extensions.dart';

/*
Open screen advertisement  ca-app-pub-3940256099942544/5575463023
 
Responsive banner  ca-app-pub-3940256099942544/2435281174
 
Fixed size banner  ca-app-pub-3940256099942544/2934735716
 
Interstitial ads  ca-app-pub-3940256099942544/4411468910
 
Rewarded advertising  ca-app-pub-3940256099942544/1712485313
 
Interstitial rewarded ads  ca-app-pub-3940256099942544/6978759866
 
Native code  ca-app-pub-3940256099942544/3986624511
 
Native video ads  ca-app-pub-3940256099942544/2521693316

application id：1:133440251506:ios:28b49dfd89112a067944eb
application encoding id：
app-1-133440251506-ios-28b49dfd89112a067944eb

*/

// Initialised in `MyApp`
class GoogleAdsController extends GetxController {
  BannerAd? _bannerAd;
  final _bannerAdIsLoaded = false.obs;

  // TODO: replace this test ad unit with your own ad unit.
  final _rewardAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  // TODO: replace this test ad unit with your own ad unit.
  final _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/2435281174'
      : 'ca-app-pub-3940256099942544/2435281174';

  BannerAd? get bannerAd => _bannerAd;
  bool get bannerAdIsLoaded => _bannerAdIsLoaded.value;

  /// Loads a rewarded ad.
  Future<void> loadRewardAd({
    required Function(RewardedAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) async {
    if (await _checkAppTrackingStatusForIOS()) {
      RewardedAd.load(
          adUnitId: _rewardAdUnitId,
          request: const AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
              ('$ad loaded.').log();
              // Keep a reference to the ad so you can show it later.
              onAdLoaded(ad);
              // Called when an ad request failed.
            },
            onAdFailedToLoad: (LoadAdError error) {
              ('RewardedAd failed to load: $error').log();
              onAdFailedToLoad(error);
            },
          ));
    }
  }

  void showRewardedAd({
    required RewardedAd rewardedAd,
    required Function(AdWithoutView, RewardItem) onUserEarnedReward,
  }) {
    rewardedAd.show(onUserEarnedReward: onUserEarnedReward);
  }

  /// Loads a native ad.
  void loadBannerAd() async {
    if (await _checkAppTrackingStatusForIOS()) {
      _bannerAdIsLoaded.value = false;
      _bannerAd = BannerAd(
        adUnitId: _bannerAdUnitId, // Test Ad Unit ID
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            ('Banner Ad Loaded').log();
            _bannerAdIsLoaded.value = true;
          },
          onAdFailedToLoad: (ad, error) {
            ('Banner Ad failed to load: $error').log();
            ad.dispose();
          },
        ),
      );
      _bannerAd?.load();
    }
  }

  void deleteBannerAd() {
    if (_bannerAd != null) {
      _bannerAd?.dispose();
      _bannerAd = null;
    }
  }

  Future<bool> _checkAppTrackingStatusForIOS() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      final newTrackingStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
      return _checkStatus(status: newTrackingStatus);
    }
    return _checkStatus(status: status);
  }

  bool _checkStatus({required TrackingStatus status}) {
    switch (status) {
      case TrackingStatus.notDetermined:
      case TrackingStatus.restricted:
      case TrackingStatus.denied:
        return false;
      case TrackingStatus.notSupported:
      case TrackingStatus.authorized:
        return true;
    }
  }
}
