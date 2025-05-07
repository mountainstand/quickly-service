import 'dart:async';

import 'package:flutter_vpn/flutter_vpn.dart';
import 'package:flutter_vpn/state.dart';

import '../../../../api_services/api_endpoints.dart';
import '../../../../api_services/api_services.dart';
import '../../../../api_services/models/ikev2_vpn_details_response.dart';
import '../../../../api_services/models/server_list_response.dart';
import '../../../../constants_and_extensions/constants.dart';
import '../../../../constants_and_extensions/nonui_extensions.dart';
import 'vpn_controller.dart';

class IKEV2IPSECVpnController extends VPNController {
  StreamSubscription<FlutterVpnState>? _ikev2IPSECFlutterVPNStateSS;

  @override
  Future<String> connectVPN({
    required String appName,
    required String appBundleIdentifier,
    required String uuid,
    required ServerDetailsModel serverDetailsModel,
    required VPNStatusCallback vpnStatus,
  }) async {
    if (_ikev2IPSECFlutterVPNStateSS != null) {
      await disconnect();
    }
    FlutterVpn.prepare();
    final apiService = ApiServices();
    final uri = apiService.getUri(apiEndpoint: AppServerEndpoints.ikev2);
    final jsonBody = {
      "country": serverDetailsModel.connectionCode ?? "",
      "udid": uuid,
    };
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.post,
      uri: uri,
      parameterEncoding: ParameterEncoding.formURLEncoded,
      parameters: jsonBody,
    );
    final ikev2VPNDetailsResponse =
        IKEv2VPNDetailsResponse.fromJson(responseJSON);
    final ikevCertData =
        Uri.decodeComponent(ikev2VPNDetailsResponse.data?.ikevCertData ?? "");
    // final ikevCertData = ikev2VPNDetailsResponse.data?.ikevCertData ?? "";
    ("Cert Data", ikevCertData).log();

    _ikev2IPSECFlutterVPNStateSS =
        FlutterVpn.onStateChanged.listen((flutterVPNState) {
      ("flutterVPNState", flutterVPNState).log();
      switch (flutterVPNState) {
        case FlutterVpnState.connecting:
          vpnStatus(vpnStatusEnum: VPNStatusEnum.connecting);
          break;
        case FlutterVpnState.connected:
          vpnStatus(vpnStatusEnum: VPNStatusEnum.connected);
          break;
        case FlutterVpnState.disconnecting:
          vpnStatus(vpnStatusEnum: VPNStatusEnum.disconnecting);
          break;
        case FlutterVpnState.disconnected:
          vpnStatus(vpnStatusEnum: VPNStatusEnum.disconnected);
          break;
        case FlutterVpnState.error:
          printCharonError();
          vpnStatus(vpnStatusEnum: VPNStatusEnum.error);
          break;
      }
    });
    await FlutterVpn.connectIkev2EAP(
        server: ikev2VPNDetailsResponse.data?.serverIP ?? "",
        // server: "167.172.159.105:51820",
        username: ikev2VPNDetailsResponse.data?.user?.udid ?? "",
        password: ikev2VPNDetailsResponse.data?.user?.openvpnPassword ?? "",
        certificateString: ikevCertData);
    return ikev2VPNDetailsResponse.data?.serverIP ?? "";
  }

  printCharonError() async {
    (
      "charonErrorState",
      await FlutterVpn.charonErrorState,
    ).log();
  }

  @override
  Future<void> disconnect() async {
    switch (await FlutterVpn.currentState) {
      case FlutterVpnState.connected:
        await FlutterVpn.disconnect();
        break;
      default:
        break;
    }
    _ikev2IPSECFlutterVPNStateSS?.cancel();
    _ikev2IPSECFlutterVPNStateSS = null;
  }
}
