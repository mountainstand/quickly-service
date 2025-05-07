class Assets {
  // Shared Instance
  Assets._sharedInstance() : super();
  static final Assets _shared = Assets._sharedInstance();
  factory Assets() => _shared;

  final gifAssets = _GIFAssets();
  final imageAssets = _ImageAssets();
  final vpnCertificates = _VPNCertificates();
}

class _GIFAssets {
  // Shared Instance
  _GIFAssets._sharedInstance() : super();
  static final _GIFAssets _shared = _GIFAssets._sharedInstance();
  factory _GIFAssets() => _shared;

  //final loader = "assets/gifs/loader.gif";
  final loader = "assets/gifs/loader_2.gif";
}

class _VPNCertificates {
  // Shared Instance
  _VPNCertificates._sharedInstance() : super();
  static final _VPNCertificates _shared = _VPNCertificates._sharedInstance();
  factory _VPNCertificates() => _shared;

  final openVPNKey = "assets/vpn_certificates/ta.key";
  final ikev2Certificate = "assets/vpn_certificates/ikev2.pem";
}

class _ImageAssets {
  // Shared Instance
  _ImageAssets._sharedInstance() : super();
  static final _ImageAssets _shared = _ImageAssets._sharedInstance();
  factory _ImageAssets() => _shared;

  // bottom_bar_icons
  final homeFilledIcon = "assets/images/bottom_bar_icons/home_filled_icon.svg";
  final homeIcon = "assets/images/bottom_bar_icons/home_icon.svg";
  final inAppFilledPurchaseIcon =
      "assets/images/bottom_bar_icons/in_app_purchase_filled_icon.svg";
  final inAppPurchaseIcon =
      "assets/images/bottom_bar_icons/in_app_purchase_icon.svg";
  final menuFilledIcon = "assets/images/bottom_bar_icons/menu_filled_icon.svg";
  final menuIcon = "assets/images/bottom_bar_icons/menu_icon.svg";
  final speedFilledTestIcon =
      "assets/images/bottom_bar_icons/speed_test_filled_icon.svg";
  final speedTestIcon = "assets/images/bottom_bar_icons/speed_test_icon.svg";

  // common
  final appIcon = "assets/images/common/app_icon.png";
  final downloadIcon = "assets/images/common/download_icon.svg";
  final uploadIcon = "assets/images/common/upload_icon.svg";
  final worldMapImage = "assets/images/common/world_map.png";

  // connect_vpn
  final powerIcon = "assets/images/connect_vpn/power_icon.svg";
  final translateIcon = "assets/images/connect_vpn/translate_icon.svg";
  final serverListIcon = "assets/images/connect_vpn/server_list_icon.svg";

  // in_app_purchase
  final premiumBenefitsImage =
      "assets/images/in_app_purchase/premium_benefits_image.svg";
  final worldMapCurvedImage =
      "assets/images/in_app_purchase/world_map_curved.png";

  //login
  final appleLogoIcon = "assets/images/login/apple_logo_icon.svg";
  final emailIcon = "assets/images/login/email_icon.svg";

  final googleLogoImage = "assets/images/login/google_logo_image.svg";
  final passwordIcon = "assets/images/login/password_icon.svg";
  final passwordInvisibleIcon =
      "assets/images/login/password_invisible_icon.svg";
  final passwordVisibleIcon = "assets/images/login/password_visible_icon.svg";
  final worldMapCurvedCentered =
      "assets/images/login/world_map_curved_centered.png";

  // server_locations
  final switchIcon = "assets/images/server_locations/switch_icon.svg";
  final signalIcon = "assets/images/server_locations/signal_icon.svg";
  final premiumIcon = "assets/images/server_locations/premium_icon.svg";

  // speed_test
  final downloadDownwardGraph =
      "assets/images/speed_test/download_downward_graph.svg";
  final downloadUpwardGraph =
      "assets/images/speed_test/download_upward_graph.svg";
  final internetSpeedIcon = "assets/images/speed_test/internet_speed_icon.svg";
  final uploadDownwardGraph =
      "assets/images/speed_test/upload_downward_graph.svg";
  final uploadUpwardGraph = "assets/images/speed_test/upload_upward_graph.svg";
  final speedTestHistoryIcon =
      "assets/images/speed_test/speed_test_history_icon.svg";

  //profile
  final signOutIcon = "assets/images/profile/sign_out_icon.svg";
}
