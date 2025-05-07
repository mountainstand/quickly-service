import '../constants_and_extensions/urls.dart';

abstract class APIEndpoints {
  String get baseURL;
  String get apiMidPoint;
  String get endpoint;
  String get getURL => "$baseURL$endpoint"; // Default implementation
}

enum API64Endpoints implements APIEndpoints {
  blank("");

  @override
  // String get baseURL => "https://api64.ipify.org/"; get ipv6 address sometimes
  String get baseURL => "https://api.ipify.org/";

  @override
  String get apiMidPoint => "";

  @override
  final String endpoint;

  const API64Endpoints(this.endpoint);

  @override
  String get getURL =>
      "$baseURL$apiMidPoint$endpoint"; // Default implementation
}

enum AppServerEndpoints implements APIEndpoints {
  connect("connect"),
  openVPN("open-vpn"),
  speedTest("speedtest"),
  ikev2("ikev2"),
  register("auth/register"),
  login("auth/login"),
  socialSignIn("auth/social-signin"),
  forgetPassword("auth/forget-password"),
  userDetail("fetch-userdetail"),
  deleteUser("auth/delete-user"),
  fetchServers("fetch-servers");

  @override
  String get baseURL => AppDomain.baseURL;

  @override
  String get apiMidPoint => AppUrls.apiMidPoint;

  @override
  final String endpoint;

  const AppServerEndpoints(this.endpoint);

  // @override
  // String get endpoint {
  //   switch (this) {
  //     case ApiEndPoints.connect:
  //       return "connect";
  //     case ApiEndPoints.speedtest:
  //       return "speedtest";
  //   }
  // }

  @override
  String get getURL =>
      "$baseURL$apiMidPoint$endpoint"; // Default implementation
}

// sealed class AppServerEndpoints implements APIEndpoints {
//   const AppServerEndpoints();

//   @override
//   String get baseURL => AppUrls.apiBaseURL;
//   @override
//   String get getURL => "$baseURL$endpoint";
//   @override
//   String get endpoint;
// }

// class Connect extends AppServerEndpoints {
//   const Connect() : super();

//   @override
//   String get endpoint => "connect";
// }

// class Speedtest extends AppServerEndpoints {
//   const Speedtest() : super();

//   @override
//   String get endpoint => "speedtest";
// }
