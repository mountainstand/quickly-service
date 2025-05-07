import '../../../../api_services/models/server_list_response.dart';

typedef VPNStatusCallback = void Function({
  required VPNStatusEnum vpnStatusEnum,
});

enum VPNStatusEnum { connecting, connected, disconnecting, disconnected, error }

abstract class VPNController {
  /// Connects to a VPN server based on the provided parameters.
  ///
  /// - [appName]: The name of your application.
  /// - [appBundleIdentifier]: The bundle identifier of the app.
  /// - [uuid]: The unique user ID used for generating certificates on the server.
  ///   To create one certificate per user.
  /// - [countryModel]: The country model containing server details
  ///   for the VPN connection, determining which VPN server to connect to.
  /// - [vpnStatus]: A callback that returns the VPN connection status,
  ///   sending VPNStatusEnum.
  Future<String> connectVPN({
    required String appName,
    required String appBundleIdentifier,
    required String uuid,
    required ServerDetailsModel serverDetailsModel,
    required VPNStatusCallback vpnStatus,
  });
  Future<void> disconnect();
}
