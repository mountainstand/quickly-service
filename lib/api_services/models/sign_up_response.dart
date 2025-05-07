import 'login_response.dart';

class SignUpResponse {
  final bool? success;
  final UserLoginModel? data;
  final String? message;

  SignUpResponse({
    this.success,
    this.data,
    this.message,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
        success: json["success"],
        data:
            json["data"] == null ? null : UserLoginModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };
}
