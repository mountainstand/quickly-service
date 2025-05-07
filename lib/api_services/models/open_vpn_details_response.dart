import 'wireguard_details_response.dart';

class OpenVPNDetailsResponse {
  final bool? success;
  final OpenVPNServerDetailsModel? data;
  final String? message;

  OpenVPNDetailsResponse({
    this.success,
    this.data,
    this.message,
  });

  factory OpenVPNDetailsResponse.fromJson(Map<String, dynamic> json) =>
      OpenVPNDetailsResponse(
        success: json["success"],
        data: json["data"] == null
            ? null
            : OpenVPNServerDetailsModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class OpenVPNServerDetailsModel {
  final UserModel? user;
  final String? serverIP;
  final String? ovpn;

  OpenVPNServerDetailsModel({
    this.user,
    this.serverIP,
    this.ovpn,
  });

  factory OpenVPNServerDetailsModel.fromJson(Map<String, dynamic> json) =>
      OpenVPNServerDetailsModel(
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        serverIP: json["serverIp"],
        ovpn: json["ovpn"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "serverIp": serverIP,
        "ovpn": ovpn,
      };
}
