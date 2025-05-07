import 'wireguard_details_response.dart';

class ProfileResponse {
  final bool? success;
  final UserModel? data;
  final String? message;

  ProfileResponse({
    this.success,
    this.data,
    this.message,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        success: json["success"],
        data: json["data"] == null ? null : UserModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}
