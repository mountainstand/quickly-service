import 'wireguard_details_response.dart';

class LoginResponse {
  final bool? success;
  final UserLoginModel? data;
  final String? message;

  LoginResponse({
    this.success,
    this.data,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
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

class UserLoginModel {
  final String? token;
  final UserModel? user;

  UserLoginModel({
    this.token,
    this.user,
  });

  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
        token: json["token"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}
