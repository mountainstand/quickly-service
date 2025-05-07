import 'dart:io';

// import 'package:openvpn_flutter/openvpn_flutter.dart';

import 'package:openvpn_flutter/openvpn_flutter.dart';

import '../../../../api_services/api_endpoints.dart';
import '../../../../api_services/api_services.dart';
import '../../../../api_services/models/open_vpn_details_response.dart';
import '../../../../api_services/models/server_list_response.dart';
import '../../../../constants_and_extensions/constants.dart';
import '../../../../constants_and_extensions/nonui_extensions.dart';
import 'vpn_controller.dart';

class OpenVpnController extends VPNController {
  OpenVPN? _openVPN;

  bool _hasStartedConnectingOnce = false;

  @override
  Future<String> connectVPN({
    required String appName,
    required String appBundleIdentifier,
    required String uuid,
    required ServerDetailsModel serverDetailsModel,
    required VPNStatusCallback vpnStatus,
  }) async {
    if (_openVPN != null) {
      await disconnect();
    }
    _hasStartedConnectingOnce = false;
    _openVPN = OpenVPN(
        onVpnStatusChanged: (VpnStatus? vpnStatus) {},
        onVpnStageChanged: (VPNStage stage, String rawStage) {
          switch (stage) {
            case VPNStage.prepare:
            case VPNStage.authenticating:
            case VPNStage.authentication:
            case VPNStage.connecting:
            case VPNStage.wait_connection:
            case VPNStage.vpn_generate_config:
            case VPNStage.get_config:
            case VPNStage.tcp_connect:
            case VPNStage.udp_connect:
            case VPNStage.assign_ip:
            case VPNStage.resolve:
              _hasStartedConnectingOnce = true;
              vpnStatus(vpnStatusEnum: VPNStatusEnum.connecting);
              break;
            case VPNStage.connected:
              vpnStatus(vpnStatusEnum: VPNStatusEnum.connected);
              break;
            case VPNStage.exiting:
            case VPNStage.disconnecting:
              vpnStatus(vpnStatusEnum: VPNStatusEnum.disconnecting);
              break;
            case VPNStage.disconnected:
              if (_hasStartedConnectingOnce) {
                vpnStatus(vpnStatusEnum: VPNStatusEnum.disconnected);
              }
              break;
            case VPNStage.denied:
              vpnStatus(vpnStatusEnum: VPNStatusEnum.error);
              break;
            case VPNStage.error:
              vpnStatus(vpnStatusEnum: VPNStatusEnum.disconnected);
              break;
            case VPNStage.unknown:
              break;
          }
        });
    final apiService = ApiServices();
    final uri = apiService.getUri(apiEndpoint: AppServerEndpoints.openVPN);
    final jsonBody = {
      "country": serverDetailsModel.connectionCode ?? "",
      "udid": "DCizXaFjUdNUFZClCgMH81cCcA03",
    };
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.post,
      uri: uri,
      parameterEncoding: ParameterEncoding.formURLEncoded,
      parameters: jsonBody,
    );
    final openVPNDetailsResponse =
        OpenVPNDetailsResponse.fromJson(responseJSON);
    final String extensionBundleIdentifier;
    if (Platform.isIOS) {
      extensionBundleIdentifier =
          "$appBundleIdentifier.OpenVPNNetworkExtensioniOS";
    } else {
      extensionBundleIdentifier = appBundleIdentifier;
    }
    ("Open VPN Response:", openVPNDetailsResponse).log();
    ("Extension ID:", extensionBundleIdentifier).log();
    ("groupIdentifier ID:", "group.$appBundleIdentifier").log();
    await _openVPN!.initialize(
      groupIdentifier: "group.$appBundleIdentifier", // used for iOS only
      providerBundleIdentifier: extensionBundleIdentifier, // used for iOS only
      localizedDescription: appName,
      lastStage: (stage) {},
    );
    // final config =
    //     await rootBundle.loadString(Assets().vpnCertificates.openVPN);
    final config = Uri.decodeComponent(openVPNDetailsResponse.data?.ovpn ?? "");
    // (openVPNDetailsResponse.data?.ovpn ?? "").replaceAll("%2F", "/");
    try {
      final connection = _openVPN!.connect(
        config,
        appName,
        username: openVPNDetailsResponse.data?.user?.udid,
        password: openVPNDetailsResponse.data?.user?.openvpnPassword,
        certIsRequired: true,
      );

      /// in case of [Android] donot await for this function as it does not return any value
      if (Platform.isIOS) await connection;
      return openVPNDetailsResponse.data?.serverIP ?? "";
    } catch (e) {
      ("error", e).log();
      e.log();
    }
    return "";
  }

  @override
  Future<void> disconnect() async {
    if (_openVPN != null && await _openVPN!.isConnected()) {
      _openVPN?.disconnect();
      _openVPN = null;
    }
  }
}
