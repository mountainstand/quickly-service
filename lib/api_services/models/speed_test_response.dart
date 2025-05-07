import 'package:flutter/foundation.dart';

import '../../constants_and_extensions/nonui_extensions.dart';

@immutable
class SpeedTestResponse {
  final bool? success;
  final InternetSpeedModel? data;
  final String? message;

  const SpeedTestResponse({
    this.success,
    this.data,
    this.message,
  });

  factory SpeedTestResponse.fromJson(Map<String, dynamic> json) =>
      SpeedTestResponse(
        success: json["success"],
        data: json["data"] == null
            ? null
            : InternetSpeedModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

@immutable
class InternetSpeedModel {
  final String? download;
  final String? upload;
  final double? ping;
  final String? isp;
  final InternetSpeedServerModel? server;

  const InternetSpeedModel({
    this.download,
    this.upload,
    this.ping,
    this.isp,
    this.server,
  });

  factory InternetSpeedModel.fromJson(Map<String, dynamic> json) =>
      InternetSpeedModel(
        download: json["download"],
        upload: json["upload"],
        ping: json["ping"]?.toDouble(),
        isp: json["isp"],
        server: json["server"] == null
            ? null
            : InternetSpeedServerModel.fromJson(json["server"]),
      );

  Map<String, dynamic> toJson() => {
        "download": download,
        "upload": upload,
        "ping": ping,
        "isp": isp,
        "server": server?.toJson(),
      };

  double get getDownloadSpeed => (download?.getDoubleValue() ?? 0.0) / 100;
  double get getUploadSpeed => (upload?.getDoubleValue() ?? 0.0) / 100;
}

@immutable
class InternetSpeedServerModel {
  final String? name;
  final String? location;

  const InternetSpeedServerModel({
    this.name,
    this.location,
  });

  factory InternetSpeedServerModel.fromJson(Map<String, dynamic> json) =>
      InternetSpeedServerModel(
        name: json["name"],
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "location": location,
      };
}
