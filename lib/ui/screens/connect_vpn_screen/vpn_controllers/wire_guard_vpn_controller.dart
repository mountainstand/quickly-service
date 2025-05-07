import 'dart:async';
import 'dart:io';

import 'package:wireguard_flutter/wireguard_flutter.dart';

import '../../../../api_services/api_endpoints.dart';
import '../../../../api_services/api_services.dart';
import '../../../../api_services/models/server_list_response.dart';
import '../../../../api_services/models/wireguard_details_response.dart';
import '../../../../constants_and_extensions/constants.dart';
import '../../../../constants_and_extensions/nonui_extensions.dart';
import 'vpn_controller.dart';

class WireGuardVPNController extends VPNController {
  //for WireGuard Implementation
  StreamSubscription<VpnStage>? _wireguardVPNStageSS;
  final _wireguard = WireGuardFlutter.instance;

  bool _hasStartedConnectingOnce = false;
  bool _hasInitiatedDisconnted = false;

  @override
  Future<String> connectVPN({
    required String appName,
    required String appBundleIdentifier,
    required String uuid,
    required ServerDetailsModel serverDetailsModel,
    required VPNStatusCallback vpnStatus,
  }) async {
    if (_wireguardVPNStageSS != null) {
      await disconnect();
    }
    await _wireguard.initialize(
        interfaceName: Platform.isAndroid ? "wg0" : appName);
    _hasStartedConnectingOnce = false;
    //attach listner
    _wireguardVPNStageSS = _wireguard.vpnStageSnapshot.listen((event) {
      ("WireGaurd VPN status changed $event").log();
      switch (event) {
        case VpnStage.preparing:
        case VpnStage.connecting:
        case VpnStage.authenticating:
        case VpnStage.waitingConnection:
          _hasStartedConnectingOnce = true;
          vpnStatus(vpnStatusEnum: VPNStatusEnum.connecting);
          break;
        case VpnStage.connected:
          if (_hasInitiatedDisconnted == false) {
            vpnStatus(vpnStatusEnum: VPNStatusEnum.connected);
          }
          break;
        case VpnStage.disconnecting:
        case VpnStage.exiting:
          vpnStatus(vpnStatusEnum: VPNStatusEnum.disconnecting);
          break;
        case VpnStage.reconnect:
        case VpnStage.noConnection:
        case VpnStage.disconnected:
          ("Logged here", _hasStartedConnectingOnce).log();
          if (_hasStartedConnectingOnce) {
            vpnStatus(vpnStatusEnum: VPNStatusEnum.disconnected);
          }
          break;
        case VpnStage.denied:
          vpnStatus(vpnStatusEnum: VPNStatusEnum.error);
          break;
      }
    });

    final apiService = ApiServices();
    final uri = apiService.getUri(apiEndpoint: AppServerEndpoints.connect);
    final jsonBody = {
      "country": serverDetailsModel.connectionCode ?? "",
      "udid": uuid,
    };
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.post,
      uri: uri,
      parameterEncoding: ParameterEncoding.jsonBody,
      parameters: jsonBody,
    );
    ("responseJSON", responseJSON).log();
    final wireguardResponse = WireguardDetailsResponse.fromJson(responseJSON);
    final wireGuardConfig = '''
[Interface]
PrivateKey = ${wireguardResponse.user?.privateKey ?? 'defaultPrivateKey'}
Address = ${wireguardResponse.user?.wireguardIPAddress ?? 'defaultIPAddress'}
DNS = ${wireguardResponse.dns ?? '8.8.8.8'}

[Peer]
PublicKey = ${wireguardResponse.serverPublickey ?? 'defaultServerPublicKey'}
AllowedIPs = ${wireguardResponse.allowedips ?? '0.0.0.0/0, ::/0'}
Endpoint = ${wireguardResponse.endpoint ?? 'defaultEndpoint'}
''';
    final ipAddress = wireguardResponse.endpoint ?? "";

    final String extensionBundleIdentifier;
    if (Platform.isIOS) {
      extensionBundleIdentifier =
          "$appBundleIdentifier.WireGuardNetworkExtensioniOS";
    } else {
      extensionBundleIdentifier = appBundleIdentifier;
    }
    await _wireguard.startVpn(
      serverAddress: '${wireguardResponse.endpoint}',
      // the server address (e.g 'demo.wireguard.com:51820')
      wgQuickConfig: wireGuardConfig,
      // the quick-config file
      providerBundleIdentifier: extensionBundleIdentifier, // used for iOS only
    );

    // if (Platform.isIOS) {
    // _attachListner(vpnStatus: vpnStatus);
    // }

    return ipAddress;
  }

  @override
  Future<void> disconnect() async {
    if (await _wireguard.isConnected()) {
      _hasInitiatedDisconnted = true;
      try {
        "WireGuard Disconnected".log();
        await _wireguard.stopVpn();
        "WireGuard Stopped".log();
      } catch (e) {
        ("Error in disconnect of WireGaurd:", e).log();
      }
      _hasInitiatedDisconnted = false;
    }
    _wireguardVPNStageSS?.cancel();
    _wireguardVPNStageSS = null;
  }
}
