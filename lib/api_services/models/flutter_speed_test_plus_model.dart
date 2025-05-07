import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';

class FlutterSpeedTestPlusModel {
  final TestResult? downloadResult;
  final TestResult? uploadResult;

  FlutterSpeedTestPlusModel({
    this.downloadResult,
    this.uploadResult,
  });

  factory FlutterSpeedTestPlusModel.fromJson(Map<String, dynamic> json) =>
      FlutterSpeedTestPlusModel(
        downloadResult: json["download_result"] == null
            ? null
            : JSONConversionOnTestResult.fromJSON(json["download_result"]),
        uploadResult: json["upload_result"] == null
            ? null
            : JSONConversionOnTestResult.fromJSON(json["upload_result"]),
      );

  Map<String, dynamic> toJson() => {
        "download_result": downloadResult?.toJSON(),
        "upload_result": uploadResult?.toJSON(),
      };
}

extension JSONConversionOnTestResult on TestResult {
  static TestResult fromJSON(Map<String, dynamic> json) => TestResult(
        TestType.values.byName(json["type"]),
        json["transfer_rate"],
        SpeedUnit.values.byName(json["unit"]),
        durationInMillis: json["duration_in_millis"],
      );

  Map<String, dynamic> toJSON() => {
        "type": type.name,
        "transfer_rate": transferRate,
        "unit": unit.name,
        "duration_in_millis": durationInMillis,
      };
}
