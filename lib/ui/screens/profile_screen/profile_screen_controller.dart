import 'package:get/get.dart';

import '../../../api_services/api_endpoints.dart';
import '../../../api_services/api_services.dart';
import '../../../api_services/models/profile_response.dart';
import '../../../api_services/models/wireguard_details_response.dart';
import '../../../constants_and_extensions/constants.dart';
import '../../../constants_and_extensions/nonui_extensions.dart';
import '../../../constants_and_extensions/shared_prefs.dart';

class ProfileScreenController extends GetxController {
  final _userDetails = UserModel.fromJson(
          SharedPrefs().getJSON(fromKey: SharedPrefsKeys.userDetails) ?? {})
      .obs;

  UserModel get userDetails => _userDetails.value;

  Future<void> getUserDetails() async {
    final apiService = ApiServices();
    final uri = apiService.getUri(
      apiEndpoint: AppServerEndpoints.userDetail,
    );
    final token =
        SharedPrefs().getString(fromKey: SharedPrefsKeys.authToken) ?? "";
    final headers = {
      "Authorization": "Bearer $token",
    };
    final responseJSON = await apiService.hitApi(
      httpMethod: HttpMehod.get,
      uri: uri,
      extraHeaders: headers,
    );
    ("Profile Response", responseJSON).log();
    if (responseJSON != null) {
      final response = ProfileResponse.fromJson(responseJSON);
      if (response.success == true && response.data != null) {
        ("Got Response", responseJSON).log();
        SharedPrefs().setJSON(
          inKey: SharedPrefsKeys.userDetails,
          value: response.data!.toJson(),
        );
        _userDetails.value = response.data!;
      }
    }
  }
}
