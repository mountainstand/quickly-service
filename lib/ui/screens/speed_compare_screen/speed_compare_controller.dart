import 'package:get/get.dart';

import '../../../api_services/models/flutter_speed_test_plus_model.dart';
import '../../../constants_and_extensions/constants.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../constants_and_extensions/shared_prefs.dart';
import 'internet_speed_compared_model.dart';

/// Initialised in [SpeedCompareScree]`
class SpeedCompareController extends GetxController {
  final _isBeforeSelected = false.obs;

  FlutterSpeedTestPlusModel? _vpnSpeedModel;
  FlutterSpeedTestPlusModel? _withouVPNSpeedModel;

  bool get isBeforeSelected => _isBeforeSelected.value;
  FlutterSpeedTestPlusModel? get vpnSpeedModel => _vpnSpeedModel;
  FlutterSpeedTestPlusModel? get withouVPNSpeedModel => _withouVPNSpeedModel;

  FlutterSpeedTestPlusModel? get selectedSpeedModel =>
      isBeforeSelected ? withouVPNSpeedModel ?? vpnSpeedModel : vpnSpeedModel;

  InternetSpeedComparedModel get downloadInternetDetails {
    final withouVPNSpeed =
        withouVPNSpeedModel?.downloadResult?.transferRate ?? 0.0;
    final vpnSpeed = vpnSpeedModel?.downloadResult?.transferRate ?? 0.0;

    if (isBeforeSelected) {
      double percentageDifference =
          vpnSpeed > 0 ? ((withouVPNSpeed - vpnSpeed) / vpnSpeed) * 100 : 0.0;

      return InternetSpeedComparedModel(
        hasIncreased: withouVPNSpeed > vpnSpeed,
        speed: "${withouVPNSpeed.formatDouble(to: 2)} Mbps",
        percentageDifference: "${percentageDifference.formatDouble(to: 2)}%",
      );
    }

    double percentageDifference = withouVPNSpeed > 0
        ? ((vpnSpeed - withouVPNSpeed) / withouVPNSpeed) * 100
        : 0.0;

    return InternetSpeedComparedModel(
      hasIncreased: vpnSpeed > withouVPNSpeed,
      speed: "${vpnSpeed.formatDouble(to: 2)} Mbps",
      percentageDifference: "${percentageDifference.formatDouble(to: 2)}%",
    );
  }

  InternetSpeedComparedModel get uploadInternetDetails {
    final withouVPNSpeed =
        withouVPNSpeedModel?.uploadResult?.transferRate ?? 0.0;
    final vpnSpeed = vpnSpeedModel?.uploadResult?.transferRate ?? 0.0;

    if (isBeforeSelected) {
      double percentageDifference =
          vpnSpeed > 0 ? ((withouVPNSpeed - vpnSpeed) / vpnSpeed) * 100 : 0.0;

      return InternetSpeedComparedModel(
        hasIncreased: withouVPNSpeed > vpnSpeed,
        speed: "${withouVPNSpeed.formatDouble(to: 2)} Mbps",
        percentageDifference: "${percentageDifference.formatDouble(to: 2)}%",
      );
    }

    double percentageDifference = withouVPNSpeed > 0
        ? ((vpnSpeed - withouVPNSpeed) / withouVPNSpeed) * 100
        : 0.0;

    return InternetSpeedComparedModel(
      hasIncreased: vpnSpeed > withouVPNSpeed,
      speed: "${vpnSpeed.formatDouble(to: 2)} Mbps",
      percentageDifference: "${percentageDifference.formatDouble(to: 2)}%",
    );
  }

  void setData() {
    final speedBeforeVPNJSON =
        SharedPrefs().getJSON(fromKey: SharedPrefsKeys.speedBeforeVPN);
    speedBeforeVPNJSON?.log();
    if (speedBeforeVPNJSON != null) {
      _withouVPNSpeedModel =
          FlutterSpeedTestPlusModel.fromJson(speedBeforeVPNJSON);
    } else {
      _withouVPNSpeedModel = null;
    }

    final speedAfterVPNJSON =
        SharedPrefs().getJSON(fromKey: SharedPrefsKeys.speedAfterVPN);
    speedAfterVPNJSON?.log();
    if (speedAfterVPNJSON != null) {
      _vpnSpeedModel = FlutterSpeedTestPlusModel.fromJson(speedAfterVPNJSON);
    } else {
      _vpnSpeedModel = null;
    }

    _vpnSpeedModel?.log();
    _withouVPNSpeedModel?.log();

    if (_vpnSpeedModel == null) {
      _isBeforeSelected.value = true;
    } else {
      _isBeforeSelected.value = false;
    }
  }

  void setBeforeSelected({
    required bool value,
  }) {
    if (_isBeforeSelected.value != value) {
      _isBeforeSelected.value = value;
    }
  }
}
