import 'package:flutter/foundation.dart';

@immutable
class WireguardDetailsResponse {
  final bool? success;
  final String? config;
  final UserModel? user;
  final String? dns;
  final String? allowedips;
  final String? endpoint;
  final String? serverPublickey;

  const WireguardDetailsResponse({
    this.success,
    this.config,
    this.user,
    this.dns,
    this.allowedips,
    this.endpoint,
    this.serverPublickey,
  });

  factory WireguardDetailsResponse.fromJson(Map<String, dynamic> json) =>
      WireguardDetailsResponse(
        success: json["success"],
        config: json["config"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        dns: json["dns"],
        allowedips: json["allowedips"],
        endpoint: json["endpoint"],
        serverPublickey: json["server_publickey"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "config": config,
        "user": user?.toJson(),
        "dns": dns,
        "allowedips": allowedips,
        "endpoint": endpoint,
        "server_publickey": serverPublickey,
      };
}

@immutable
class UserModel {
  final String? id;
  final String? udid;
  final String? email;
  final String? userName;
  final String? publicKey;
  final String? privateKey;
  final String? wireguardIPAddress;
  final String? openvpnPassword;
  final DateTime? lastConnection;
  final int? v;

  const UserModel({
    this.id,
    this.udid,
    this.email,
    this.userName,
    this.publicKey,
    this.privateKey,
    this.wireguardIPAddress,
    this.openvpnPassword,
    this.lastConnection,
    this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        udid: json["udid"],
        email: json["email"],
        userName: json["userName"],
        publicKey: json["publicKey"],
        privateKey: json["privateKey"],
        wireguardIPAddress: json["wireguardIpAddress"],
        openvpnPassword: json["openvpnPassword"],
        lastConnection: json["lastConnection"] == null
            ? null
            : DateTime.parse(json["lastConnection"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "udid": udid,
        "email": email,
        "userName": userName,
        "publicKey": publicKey,
        "privateKey": privateKey,
        "wireguardIpAddress": wireguardIPAddress,
        "openvpnPassword": openvpnPassword,
        "lastConnection": lastConnection?.toIso8601String(),
        "__v": v,
      };
}
