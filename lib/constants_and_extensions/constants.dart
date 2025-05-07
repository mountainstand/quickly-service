import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum HttpMehod { get, post, put, delete }

enum ParameterEncoding {
  none,
  formURLEncoded,
  jsonBody,
  formData,
  // imageUpload
}

enum JsonDecoderEnum { none, razorPayTokenReponse }

enum JsonStructEnum { onlyModel, onlyJson, both }

enum ApiStatus { notHitOnce, isBeingHit, apiHit, apiHitWithError }

enum VPNProtocol {
  wireGuard,
  openVPN,
  ikev2IPSEC;

  String title({required BuildContext context}) {
    switch (this) {
      case VPNProtocol.wireGuard:
        return AppLocalizations.of(context)!.wireGuard;
      case VPNProtocol.openVPN:
        return AppLocalizations.of(context)!.openVPN;
      case VPNProtocol.ikev2IPSEC:
        return AppLocalizations.of(context)!.ikev2IPSEC;
    }
  }
}

enum SharedPrefsKeys {
  fcmToken("fcm_token"),
  authToken("auth_token"),
  theme("theme"),
  speedBeforeVPN("speed_test_model_without_vpn"),
  speedAfterVPN("speed_test_model_with_vpn"),
  purchaseDetails("purchase_details"),
  userDetails("user_details"),
  ;

  final String value;
  const SharedPrefsKeys(this.value);
}
