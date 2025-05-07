import 'dart:async';

import 'package:get/get.dart';

import '../constants_and_extensions/internet_connectivity.dart';

/// Initialised in [MyApp]
class NetworkController extends GetxController {
  final _hasInternetConnection = true.obs; // Observable for internet status

  bool get hasInternetConnection => _hasInternetConnection.value;

  StreamSubscription<bool>? _interConnectionSS;

  @override
  void onReady() {
    super.onReady();
    _listenToInternetStatus();
  }

  void _listenToInternetStatus() {
    Future.delayed(Duration(seconds: 3), () {
      _interConnectionSS =
          InternetConnectivity().checkInternetConnectionStream.listen((status) {
        _hasInternetConnection.value = status;
      });
    });
  }

  void cancelSteams() {
    _interConnectionSS?.cancel();
    _interConnectionSS = null;
  }
}
