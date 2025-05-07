import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../api_services/api_endpoints.dart';
import '../api_services/api_services.dart';
import '../api_services/models/base_response.dart';
import '../api_services/models/login_response.dart';
import '../api_services/models/sign_up_response.dart';
import '../api_services/models/wireguard_details_response.dart';
import '../constants_and_extensions/constants.dart';
import '../constants_and_extensions/nonui_extensions.dart';
import '../constants_and_extensions/shared_prefs.dart';
import '../ui/screens/login/google_sign_in_manager.dart';
import '../ui/screens/login/sign_in_with_apple_manager.dart';

enum SocialLoginType { google, apple }

/// Initialised in [MyApp]
class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _isUserLoggedIn = false.obs;

  ///get user
  User? get currentUserDetails => _auth.currentUser;

  /// Check if the user is logged in and anonymous
  bool get isUserLoggedInAnonymously {
    User? currentUser = currentUserDetails;
    return currentUser != null && currentUser.isAnonymous;
  }

  bool get isUserLoggedIn {
    final json = SharedPrefs().getJSON(fromKey: SharedPrefsKeys.userDetails);
    _isUserLoggedIn.value = json?.isNotEmpty ?? false;
    return _isUserLoggedIn.value;
  }

  @override
  void onReady() {
    signInAnonymously();
    isUserLoggedIn;
    super.onReady();
  }

  /// Sign-In Anonymously
  Future<void> signInAnonymously() async {
    if (!isUserLoggedInAnonymously) {
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        ("Signed in with anonymous account:", userCredential).log();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            ("Anonymous auth hasn't been enabled for this project.").log();
            break;
          default:
            ("Unknown error:", e).log();
        }
      }
    } else {
      ("Already signed in with anonymous account:", _auth.currentUser).log();
    }
  }

  Future<void> _logoutFromSocialLoginsAndClearSharedPrefs() async {
    await GoogleSignInManager().signOut();
    await SignInWithAppleManager().signOut();
    SharedPrefs().delete(fromKey: SharedPrefsKeys.authToken);
    SharedPrefs().delete(fromKey: SharedPrefsKeys.userDetails);
    _isUserLoggedIn.value = false;
  }

  Future<void> _setSharedPrefsOnLogin({
    required String token,
    required UserModel userModel,
  }) async {
    SharedPrefs().setString(
      inKey: SharedPrefsKeys.authToken,
      value: token,
    );
    SharedPrefs().setJSON(
      inKey: SharedPrefsKeys.userDetails,
      value: userModel.toJson(),
    );
    _isUserLoggedIn.value = true;
  }

  Future<
      ({
        bool success,
        String message,
      })> signInWithGoogle() async {
    await signInAnonymously();

    final signInWithGoogleResult = await GoogleSignInManager().signIn();
    return await _socialLogin(
      id: signInWithGoogleResult?.id ?? "",
      email: signInWithGoogleResult?.email ?? "",
      userName: signInWithGoogleResult?.displayName ?? "",
      socialType: SocialLoginType.google,
    );
  }

  Future<
      ({
        bool success,
        String message,
      })> signInWithApple() async {
    await signInAnonymously();
    final singInWithAppleResult = await SignInWithAppleManager().signIn();
    singInWithAppleResult.log();
    String completeName = (singInWithAppleResult.givenName ?? "");
    final familyName = singInWithAppleResult.familyName ?? "";
    if (familyName.isNotEmpty) {
      completeName = "$completeName $familyName";
    }
    return await _socialLogin(
      id: singInWithAppleResult.userIdentifier ?? "",
      email: singInWithAppleResult.email ?? "",
      userName: completeName,
      socialType: SocialLoginType.apple,
    );
  }

  Future<
      ({
        bool success,
        String message,
      })> _socialLogin({
    required String id,
    required String email,
    required String userName,
    required SocialLoginType socialType,
  }) async {
    final apiService = ApiServices();
    final uri = apiService.getUri(
      apiEndpoint: AppServerEndpoints.socialSignIn,
    );
    final parameters = {
      "udid": currentUserDetails?.uid ?? "",
    };
    if (email.isNotEmpty) {
      parameters.addAll({
        "email": email,
      });
    }
    if (userName.isNotEmpty) {
      parameters.addAll({
        "userName": userName,
      });
    }
    switch (socialType) {
      case SocialLoginType.google:
        parameters.addAll({
          "googleId": id,
          "socialType": "Google",
        });
        break;
      case SocialLoginType.apple:
        parameters.addAll({
          "appleId": id,
          "socialType": "Apple",
        });
        break;
    }
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.post,
      uri: uri,
      parameterEncoding: ParameterEncoding.jsonBody,
      parameters: parameters,
    );
    ("Social Login Response", responseJSON).log();
    if (responseJSON != null) {
      final response = LoginResponse.fromJson(responseJSON);
      if (response.success == true && response.data?.user != null) {
        ("Got Response", responseJSON).log();
        _setSharedPrefsOnLogin(
          token: response.data!.token!,
          userModel: response.data!.user!,
        );
        return (
          success: true,
          message: response.message ?? "",
        );
      } else {
        return (
          success: false,
          message: response.message ?? "",
        );
      }
    }
    return (
      success: false,
      message: "Something went wrong, please try again later"
    );
  }

  Future<({bool success, String message})> loginUserWith({
    required String email,
    required String password,
  }) async {
    await signInAnonymously();
    final apiService = ApiServices();
    final uri = apiService.getUri(
      apiEndpoint: AppServerEndpoints.login,
    );
    final parameters = {
      "uuid": currentUserDetails?.uid ?? "",
      "email": email,
      "password": password,
    };
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.post,
      uri: uri,
      parameterEncoding: ParameterEncoding.jsonBody,
      parameters: parameters,
    );
    ("Login Response", responseJSON).log();
    if (responseJSON != null) {
      final response = LoginResponse.fromJson(responseJSON);
      if (response.success == true && response.data?.user != null) {
        ("Got Response", responseJSON).log();
        _setSharedPrefsOnLogin(
          token: response.data!.token!,
          userModel: response.data!.user!,
        );
        return (
          success: true,
          message: response.message ?? "",
        );
      } else {
        return (
          success: false,
          message: response.message ?? "",
        );
      }
    }
    return (
      success: false,
      message: "Something went wrong, please try again later"
    );
  }

  Future<({bool success, String message})> registerWith({
    required String name,
    required String email,
    required String password,
  }) async {
    await signInAnonymously();
    final apiService = ApiServices();
    final uri = apiService.getUri(
      apiEndpoint: AppServerEndpoints.register,
    );
    final parameters = {
      "uuid": currentUserDetails?.uid ?? "",
      "userName": name,
      "email": email,
      "password": password,
    };
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.post,
      uri: uri,
      parameterEncoding: ParameterEncoding.jsonBody,
      parameters: parameters,
    );
    ("SignUP Response", responseJSON).log();
    if (responseJSON != null) {
      final response = SignUpResponse.fromJson(responseJSON);
      if (response.success == true && response.data?.user != null) {
        ("Got Response", responseJSON).log();
        _setSharedPrefsOnLogin(
          token: response.data!.token!,
          userModel: response.data!.user!,
        );
        return (
          success: true,
          message: response.message ?? "",
        );
      } else {
        return (
          success: false,
          message: response.message ?? "",
        );
      }
    }
    return (
      success: false,
      message: "Something went wrong, please try again later"
    );
  }

  Future<({bool success, String message})> signOut() async {
    await _logoutFromSocialLoginsAndClearSharedPrefs();
    return (
      success: true,
      message: "Logged out successfully",
    );
  }

  Future<({bool success, String message})> deleteAccount() async {
    final apiService = ApiServices();
    final uri = apiService.getUri(
      apiEndpoint: AppServerEndpoints.deleteUser,
    );
    final token =
        SharedPrefs().getString(fromKey: SharedPrefsKeys.authToken) ?? "";
    final headers = {
      "Authorization": "Bearer $token",
    };
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.delete,
      uri: uri,
      extraHeaders: headers,
    );
    ("Delete Response", responseJSON).log();
    if (responseJSON != null) {
      final response = BaseResponse.fromJson(responseJSON);
      if (response.success == true) {
        await _logoutFromSocialLoginsAndClearSharedPrefs();
        return (
          success: true,
          message: response.message ?? "Account deleted successfully",
        );
      } else {
        return (
          success: false,
          message: response.message ?? "",
        );
      }
    }
    return (
      success: false,
      message: "Something went wrong, please try again later"
    );
  }
}
