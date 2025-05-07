import 'dart:async';

import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';
import 'package:get/get.dart';

import '../api_services/models/flutter_speed_test_plus_model.dart';
import '../constants_and_extensions/constants.dart';
import '../constants_and_extensions/flutter_toast_manager.dart';
import '../constants_and_extensions/internet_connectivity.dart';
import '../constants_and_extensions/nonui_extensions.dart';
import '../constants_and_extensions/shared_prefs.dart';

/// Initialised in [MyApp]
class SpeedTestController extends GetxController {
  final _isRunningDownloadTest = false.obs;
  final _isRunningUploadTest = false.obs;
  final Rx<FlutterSpeedTestPlusModel> _internetSpeedModel =
      FlutterSpeedTestPlusModel().obs;

  bool get isRunningDownloadTest => _isRunningDownloadTest.value;
  bool get isRunningSpeedTest =>
      isRunningDownloadTest || _isRunningUploadTest.value;
  FlutterSpeedTestPlusModel get internetSpeedModel => _internetSpeedModel.value;
  double get speedToShow => _isRunningUploadTest.value
      ? internetSpeedModel.uploadResult?.transferRate ?? 0.0
      : internetSpeedModel.downloadResult?.transferRate ?? 0.0;

  // final _plugin = SpeedCheckerPlugin();
  // StreamSubscription<SpeedTestResult>? _subscription;

  final internetSpeedTest = FlutterInternetSpeedTest(); //..enableLog()

  Timer? _progressTimer;

  void _cancelTimer() {
    _progressTimer?.cancel();
  }

  Future<void> getIPDetails({required bool isVPNConnected}) async {
    if (!InternetConnectivity().isInternetConnected) {
      FlutterToastManager().showInternetNotConnectedToast();
      return;
    }
    _isRunningDownloadTest.value = true;
    // _plugin.startSpeedTest();

    // _subscription = _plugin.speedTestResultStream.listen((result) {
    //   ("Chak Data", result.currentSpeed).log();
    //   _internetSpeedModel.value = result;

    //   if (result.error.isNotEmpty) {
    //     ("result.error", result.error).log();
    //   }
    //   // SharedPrefs().setJSON(
    //   //   value: internetSpeedModel.toJson(),
    //   //   inKey: isVPNConnected
    //   //       ? SharedPrefsKeys.speedAfterVPN
    //   //       : SharedPrefsKeys.speedBeforeVPN,
    //   // );
    // }, onDone: () {
    //   "On Done".log();
    //   _disposeSusbscription();
    //   _isRunningSpeedTest.value = false;
    // }, onError: (error) {
    //   ("On Error", error).log();
    //   _disposeSusbscription();
    //   _isRunningSpeedTest.value = false;
    // });

    // var test = 0;

    // Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //   _isRunningDownloadTest.value = true;
    //   ('Callback executed after 1 second!').log();
    //   _internetSpeedModel.value = FlutterSpeedTestPlusModel(
    //     downloadResult:
    //         TestResult(TestType.download, test == 0 ? 20 : 50, SpeedUnit.mbps),
    //     uploadResult: _internetSpeedModel.value.uploadResult,
    //   );
    //   test = test == 0 ? 1 : 0;
    // });
    // return;

    void startProgressTimeout() {
      // Cancel any existing timer
      _cancelTimer();
      final seconds = 3;
      _progressTimer = Timer(Duration(seconds: seconds), () {
        ("No progress detected for $seconds seconds, calling _onTestCompleted.")
            .log();
        _onTestCompleted(
          download: _internetSpeedModel.value.downloadResult,
          upload: _internetSpeedModel.value.uploadResult,
          isVPNConnected: isVPNConnected,
        );
      });
    }

    return await internetSpeedTest.startTesting(
      onStarted: () {
        _isRunningDownloadTest.value = true;
      },
      onCompleted: (download, upload) {
        // setState(() {
        //   _downloadRate = download.transferRate;
        //   // _downloadProgress = '100';
        //   _downloadCompletionTime = download.durationInMillis;
        //   _uploadRate = upload.transferRate;
        //   // _uploadProgress = '100';
        //   _uploadCompletionTime = upload.durationInMillis;

        //   _testInProgress = false;
        // });
        "On Done".log();
        _onTestCompleted(
          download: download,
          upload: upload,
          isVPNConnected: isVPNConnected,
        );
      },
      onProgress: (percent, data) {
        startProgressTimeout();
        if (data.type == TestType.download) {
          _isRunningDownloadTest.value = true;
          ("Download rate", data.transferRate).log();
          _internetSpeedModel.value = FlutterSpeedTestPlusModel(
            downloadResult: data,
            uploadResult: _internetSpeedModel.value.uploadResult,
          );
          // _downloadRate = data.transferRate;
          // _downloadProgress = percent.toStringAsFixed(2);
        } else {
          _isRunningDownloadTest.value = false;
          _isRunningUploadTest.value = true;
          ("Upload rate", data.transferRate).log();
          // _uploadRate = data.transferRate;
          // _uploadProgress = percent.toStringAsFixed(2);

          _internetSpeedModel.value = FlutterSpeedTestPlusModel(
            downloadResult: _internetSpeedModel.value.downloadResult,
            uploadResult: data,
          );
        }
      },
      onDefaultServerSelectionInProgress: () {
        ("onDefaultServerSelectionInProgress").log();
      },
      onDefaultServerSelectionDone: (client) {
        // setState(() {
        //   _isServerSelectionInProgress = false;
        //   _ip = client?.ip;
        //   _asn = client?.asn;
        //   _isp = client?.isp;
        // });
        ("onDefaultServerSelectionDone").log();
      },
      onError: (errorMessage, speedTestError) {
        ("On Error", errorMessage).log();
        _setIsAnyTestRunningToFalse();
      },
      onCancel: () {
        ("On Cancel").log();
        _setIsAnyTestRunningToFalse();
      },
    );
  }

  void _onTestCompleted({
    required TestResult? download,
    required TestResult? upload,
    required bool isVPNConnected,
  }) {
    _cancelTimer();
    _internetSpeedModel.value = FlutterSpeedTestPlusModel(
      downloadResult: download,
      uploadResult: upload,
    );
    "_onTestCompleted".log();
    _disposeSusbscription();
    _setIsAnyTestRunningToFalse();
    SharedPrefs().setJSON(
      value: internetSpeedModel.toJson(),
      inKey: isVPNConnected
          ? SharedPrefsKeys.speedAfterVPN
          : SharedPrefsKeys.speedBeforeVPN,
    );
  }

  void _setIsAnyTestRunningToFalse() {
    _isRunningDownloadTest.value = false;
    _isRunningUploadTest.value = false;
  }

  void stopSpeedTest() {
    internetSpeedTest.cancelTest();
  }

  void _disposeSusbscription() {
    // _subscription?.cancel();
    // _subscription = null;
  }

  @override
  void dispose() {
    _disposeSusbscription();
    // _plugin.dispose();
    super.dispose();
  }
}
