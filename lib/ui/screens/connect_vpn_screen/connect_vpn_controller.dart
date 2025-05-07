import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../api_services/api_endpoints.dart';
import '../../../api_services/api_services.dart';
import '../../../api_services/models/server_list_response.dart';
import '../../../constants_and_extensions/constants.dart';
import '../../../constants_and_extensions/flutter_toast_manager.dart';
import '../../../constants_and_extensions/internet_connectivity.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../global_controllers/loader_controller.dart';
import '../../../global_controllers/login_controller.dart';
import 'vpn_controllers/ikev2_ipsec_vpn_controller.dart';
import 'vpn_controllers/open_vpn_controller.dart';
import 'vpn_controllers/vpn_controller.dart';
import 'vpn_controllers/wire_guard_vpn_controller.dart';

/// Initialised in [ConnectVPNScreen]
class ConnectVpnController extends GetxController {
  // Observable Values
  final _selectedVPNProtocol = VPNProtocol.wireGuard.obs;
  final _selectedServerDetails = ServerDetailsModel().obs;
  final _isConnected = false.obs;
  final _vpnConnectedTime = 0.obs; //it is in seconds
  final _fetchingIP = false.obs; //it is in seconds

  // Properties
  final vpnPermissionMethodChannel = MethodChannel("vpn_permission_channel");
  VPNController _vpnController = WireGuardVPNController();
  final LoaderController _loaderController = Get.find<LoaderController>();
  final LoginController _loginController = Get.find<LoginController>();
  final vpnProtocols = [VPNProtocol.wireGuard, VPNProtocol.openVPN];
  // final vpnProtocols = VPNProtocol.values;
  final _ipAddress = "".obs;
  Timer? _timer;
  final List<ServerDetailsModel> serverList = [];

  // Getters
  VPNProtocol get selectedVPNProtocol => _selectedVPNProtocol.value;
  ServerDetailsModel get selectedServerDetails => _selectedServerDetails.value;
  bool get isServerSelected =>
      selectedServerDetails.connectionCode?.isNotEmpty ?? false;
  bool get isVPNConnected => _isConnected.value;
  String get vpnConnectedTimeToShow =>
      _vpnConnectedTime.value.convertSecondsToTime();
  String get ipAddress => _ipAddress.value;
  bool get fetchingIP => _fetchingIP.value;

  @override
  void onReady() {
    getPublicIP();
    getCountriesList();
    super.onReady();
  }

  void updateSelectedProtocol({required VPNProtocol newValue}) {
    _selectedVPNProtocol.value = newValue;
    switch (newValue) {
      case VPNProtocol.wireGuard:
        _vpnController = WireGuardVPNController();
        break;
      case VPNProtocol.openVPN:
        _vpnController = OpenVpnController();
        break;
      case VPNProtocol.ikev2IPSEC:
        _vpnController = IKEV2IPSECVpnController();
        break;
    }
  }

  void getCountriesList() async {
    if (!InternetConnectivity().isInternetConnected) {
      Future.delayed(Duration(seconds: 1), () => getCountriesList());
      return;
    }
    final apiService = ApiServices();
    final uri = apiService.getUri(
      apiEndpoint: AppServerEndpoints.fetchServers,
    );
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.get,
      uri: uri,
    );
    final serverListResponse = ServerListResponse.fromJson(responseJSON);
    serverList.addAll(serverListResponse.data ?? []);

    if (serverList.any((serverDetails) =>
            serverDetails.connectionCode ==
            selectedServerDetails.connectionCode) ==
        false) {
      _selectedServerDetails.value = serverList.first;
    }
  }

  void setSelectedServer({required int at}) {
    _selectedServerDetails.value = serverList[at];
  }

  Future<void> getPublicIP({bool fromDelay = false}) async {
    if (_fetchingIP.value == true && !fromDelay) {
      ("Returned", _fetchingIP.value, "Delay", fromDelay).log();
      return;
    }
    "Fetching IP called".log();
    _fetchingIP.value = true;
    final apiService = ApiServices();
    final queryparameters = {
      "format": "json",
    };
    final uri = apiService.getUri(
      apiEndpoint: API64Endpoints.blank,
      queryparameters: queryparameters,
    );
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.get,
      uri: uri,
    );
    if (responseJSON != null && responseJSON['ip'] != null) {
      _ipAddress.value = responseJSON['ip'];
      _ipAddress.value.log();

      _fetchingIP.value = false;
    } else {
      Future.delayed(Duration(seconds: 1), () => getPublicIP(fromDelay: true));
    }
  }

  void toggleConnection({
    required String appName,
  }) {
    if (isVPNConnected) {
      _disconnectVPN();
    } else {
      _connectVPN(appName: appName);
    }
  }

  void _connectVPN({
    required String appName,
  }) async {
    if (!InternetConnectivity().isInternetConnected) {
      FlutterToastManager().showInternetNotConnectedToast();
      return;
    }
    _loaderController.showLoader();
    final packageInfo = await PackageInfo.fromPlatform();
    final appBundleIdentifier = packageInfo.packageName;
    try {
      if (Platform.isAndroid) {
        if (await requestVpnPermission(appName: appName) == false) {
          /// if [requestVpnPermission] returns false, listner is added in it
          /// which will get callback when user accepts or rejects permission
          /// then [toggleConnection] is called in the listner if user allows
          _loaderController.hideLoader();
          return;
        }
      }
      _ipAddress.value = await _vpnController.connectVPN(
        appName: appName,
        appBundleIdentifier: appBundleIdentifier,
        uuid: _loginController.currentUserDetails?.uid ?? Uuid().v4(),
        serverDetailsModel: selectedServerDetails,
        vpnStatus: ({required vpnStatusEnum}) =>
            _onVPN(vpnStatusEnum: vpnStatusEnum),
      );
    } catch (e) {
      _loaderController.hideLoader();
      ("Error in _connectVPN:", e).log();
    }
  }

  Future<bool> requestVpnPermission({required String appName}) async {
    try {
      final bool isGranted =
          await vpnPermissionMethodChannel.invokeMethod("requestVpnPermission");

      if (!isGranted) {
        ("Added observer for Android VPN Permission").log();
        _addVpnPermissionListener(appName: appName);
      } else {
        ("VPN permission already granted for Android").log();
      }
      return isGranted;
    } on PlatformException catch (e) {
      ("Failed to request VPN permission for Android: ${e.message}").log();
    }
    return false;
  }

  void _addVpnPermissionListener({required String appName}) {
    vpnPermissionMethodChannel.setMethodCallHandler((call) async {
      if (call.method == "vpnPermissionResult") {
        bool granted = call.arguments as bool;
        if (granted) {
          ("Android VPN permission granted!").log();
          toggleConnection(appName: appName);
        } else {
          ("Android VPN permission denied!").log();
        }
        _removeVpnPermissionListener();
      }
    });
  }

  void _removeVpnPermissionListener() {
    vpnPermissionMethodChannel.setMethodCallHandler(null); // Remove listener
  }

  void _onVPN({required VPNStatusEnum vpnStatusEnum}) async {
    ("_onVPN called", vpnStatusEnum).log();
    switch (vpnStatusEnum) {
      case VPNStatusEnum.connecting:
        _loaderController.showLoader();
        break;
      case VPNStatusEnum.connected:
        _isConnected.value = true;
        _loaderController.hideLoader();
        _startTimer();
        break;
      case VPNStatusEnum.disconnecting:
        _loaderController.showLoader();
        break;
      case VPNStatusEnum.disconnected:
      case VPNStatusEnum.error:
        await performDisconnectVPNSteps();
        break;
    }
  }

  Future<void> _disconnectVPN() async {
    _loaderController.showLoader();
    await performDisconnectVPNSteps();
  }

  Future<void> performDisconnectVPNSteps() async {
    _isConnected.value = false;
    _stopTimer();
    _ipAddress.value = "";
    await _vpnController.disconnect();
    ("After disconnect from _vpnController.disconnect()").log();
    getPublicIP();
    // _loaderController.hideLoader();
    //delay to avoid issue of UI getting stuck sometimes
    Future.delayed(Duration(seconds: 1), () => _loaderController.hideLoader());
  }

  void _startTimer() {
    if (_timer == null) {
      "Timer Started".log();
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
        (Timer timer) {
          ("Timer Callback").log();
          _vpnConnectedTime.value++;
        },
      );
    }
  }

  void _stopTimer() {
    "Timer Stopped".log();
    if (_timer?.isActive == true) {
      _timer?.cancel();
      _timer = null;
      _vpnConnectedTime.value = 0;
    }
  }
}
