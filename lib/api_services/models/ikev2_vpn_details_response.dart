import 'wireguard_details_response.dart';

class IKEv2VPNDetailsResponse {
  final bool? success;
  final IKEv2VPNServerDetailsModel? data;
  final String? message;

  IKEv2VPNDetailsResponse({
    this.success,
    this.data,
    this.message,
  });

  factory IKEv2VPNDetailsResponse.fromJson(Map<String, dynamic> json) =>
      IKEv2VPNDetailsResponse(
        success: json["success"],
        data: json["data"] == null
            ? null
            : IKEv2VPNServerDetailsModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}

class IKEv2VPNServerDetailsModel {
  final UserModel? user;
  final String? serverIP;
  final String? ikevCertData;

  IKEv2VPNServerDetailsModel({
    this.user,
    this.serverIP,
    this.ikevCertData,
  });

  factory IKEv2VPNServerDetailsModel.fromJson(Map<String, dynamic> json) =>
      IKEv2VPNServerDetailsModel(
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        serverIP: json["serverIp"],
        ikevCertData: json["ikevCertData"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "serverIp": serverIP,
        "ovpn": ikevCertData,
      };
}
