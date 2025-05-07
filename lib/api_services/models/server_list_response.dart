class ServerListResponse {
  final bool? success;
  final List<ServerDetailsModel>? data;
  final String? message;

  ServerListResponse({
    this.success,
    this.data,
    this.message,
  });

  factory ServerListResponse.fromJson(Map<String, dynamic> json) =>
      ServerListResponse(
        success: json["success"],
        data: json["data"] == null
            ? []
            : List<ServerDetailsModel>.from(
                json["data"]!.map((x) => ServerDetailsModel.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class ServerDetailsModel {
  final String? name;
  final String? connectionCode;
  final bool? isPremium;
  final String? image;

  ServerDetailsModel({
    this.name,
    this.connectionCode,
    this.isPremium,
    this.image,
  });

  factory ServerDetailsModel.fromJson(Map<String, dynamic> json) =>
      ServerDetailsModel(
        name: json["name"],
        connectionCode: json["connection_code"],
        isPremium: json["is_premium"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "connection_code": connectionCode,
        "is_premium": isPremium,
        "image": image,
      };
}
