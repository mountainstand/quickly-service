class AppDomain {
  static String get baseURL =>
      //"https://vpn.protool.app/"
      // "http://192.168.8.91:3000/";
      "http://167.172.159.105:3000/";
}

class AppUrls {
  static String get apiBaseURL => AppDomain.baseURL + apiMidPoint;
  static const String apiMidPoint = "api/";
  static String privacyPolicy = "${AppDomain.baseURL}privacypolicy";
}
