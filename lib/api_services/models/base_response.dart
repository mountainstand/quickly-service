import 'package:flutter/foundation.dart';

@immutable
class BaseResponse {
  final bool? success;
  final String? message;

  const BaseResponse({this.success, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
