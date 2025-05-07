import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../constants_and_extensions/constants.dart'
    show HttpMehod, ParameterEncoding;
import 'package:http/http.dart' as http;
import '../constants_and_extensions/nonui_extensions.dart';
import '../constants_and_extensions/internet_connectivity.dart';
import 'api_endpoints.dart';
import 'models/models_used_to_send_data/image_model.dart';

class ApiServices {
  StreamSubscription? subcription;

  Map<String, String> _getHeaders(Map<String, String>? extraHeaders) {
    final Map<String, String> headers = {};
    // if using third party api's then no need to send token in it
    if (extraHeaders != null) headers.addAll(extraHeaders);

    return headers;
  }

  Uri getUri(
      {required APIEndpoints apiEndpoint,
      Map<String, dynamic>? queryparameters}) {
    if (queryparameters != null) {
      final baseURL = apiEndpoint.baseURL.removeLastChar();
      final midPointAndEndpoint =
          "${apiEndpoint.apiMidPoint}${apiEndpoint.endpoint}";
      final endPoint =
          midPointAndEndpoint.isEmpty ? "" : "/$midPointAndEndpoint";
      final parametersAsString = queryparameters.toMapStringString();
      if (baseURL.substring(0, 5) == "https") {
        final urlWithoutHttps = baseURL.replaceFirst("https://", "");
        return Uri.https(urlWithoutHttps, endPoint, parametersAsString);
      }
      final urlWithoutHttp = baseURL.replaceFirst("http://", "");
      return Uri.http(urlWithoutHttp, endPoint, parametersAsString);
    } else {
      return Uri.parse(apiEndpoint.getURL);
    }
  }

  Future<http.Response> _uploadFiles(
      String httpMethod,
      Uri uri,
      Map<String, String> headers,
      Map<String, dynamic>? parameters,
      List<ImageModel> imageModel) async {
    final request = http.MultipartRequest(httpMethod, uri);
    if (parameters != null) {
      request.fields.addAll(parameters.toMapStringString());
    }
    request.headers.addAll(headers);
    for (final imageModel in imageModel) {
      request.files.add(http.MultipartFile.fromBytes(imageModel.paramName ?? "",
          File(imageModel.image?.path ?? "").readAsBytesSync(),
          filename: imageModel.paramName ?? ""));
    }
    http.StreamedResponse streamResponse = await request.send();
    return await http.Response.fromStream(streamResponse);
  }

  dynamic hitApi(
      {required HttpMehod httpMethod,
      required uri,
      bool isAuthApi = false,
      Map<String, String>? extraHeaders,
      ParameterEncoding parameterEncoding = ParameterEncoding.none,
      Map<String, dynamic>? parameters,
      List<ImageModel> imageModel = const [],
      Function? whenInternotNotConnected}) async {
    if (InternetConnectivity().isInternetConnected) {
      if (subcription != null) {
        subcription?.cancel();
      }

      final Map<String, String> headers = _getHeaders(extraHeaders);

      "httpMethod --> $httpMethod".log();
      "uri --> $uri".log();
      "queryParameters --> ${uri.queryParameters}".log();
      "headers --> $headers".log();
      "parameterEncoding --> $parameterEncoding".log();
      "parameters --> $parameters".log();

      //https://pub.dev/documentation/http/latest/http/post.html
      late final dynamic body;
      if (parameters != null) {
        switch (parameterEncoding) {
          case ParameterEncoding.jsonBody:
            body = jsonEncode(parameters);
            headers.addAll({
              "Content-Type": "application/json",
            });
            break;
          case ParameterEncoding.formURLEncoded:
            //If body is a Map, it's encoded as form fields using encoding.
            //The content-type of the request will be set to "application/x-www-form-urlencoded";
            //this cannot be overridden.
            body = parameters.map(
              (key, value) => MapEntry(
                key,
                Uri.encodeComponent(value),
              ),
            );
            headers.addAll({
              "Content-Type": "application/x-www-form-urlencoded",
            });
            break;
          default:
            body = null;
            break;
        }
      } else {
        body = null;
      }
      try {
        final http.Response response;
        switch (httpMethod) {
          case HttpMehod.get:
            response = await http.get(uri, headers: headers);
            break;
          case HttpMehod.post:
            if (imageModel.isEmpty) {
              response = await http.post(uri, headers: headers, body: body);
            } else {
              response = await _uploadFiles(
                  "POST", uri, headers, parameters, imageModel);
            }
            break;
          case HttpMehod.put:
            if (imageModel.isEmpty) {
              response = await http.put(uri, headers: headers, body: body);
            } else {
              response = await _uploadFiles(
                  "PUT", uri, headers, parameters, imageModel);
            }
            break;
          case HttpMehod.delete:
            if (imageModel.isEmpty) {
              response = await http.delete(uri, headers: headers, body: body);
            } else {
              response = await _uploadFiles(
                  "DELETE", uri, headers, parameters, imageModel);
            }
            break;
        }

        switch (response.statusCode) {
          case 401:
          //routeOnBoard
          default:
            try {
              return jsonDecode(response.body);
            } catch (exception) {
              "error in $uri --> $exception".log();
            }
        }
      } on http.ClientException catch (e) {
        ("Client Exception: $e").log();
      } on SocketException {
        ("No Internet Connection or Server Unreachable!").log();
      } on TimeoutException {
        ("Request Timed Out!").log();
      } catch (e) {
        ("Unexpected Error: $e").log();
      }
    } else {
      //Singleton.instance.generalFunctions.showToast(interetNotConnected);
      // Singleton.instance.generalFunctions.showInternetNotConnectedDialog(context, () { if (whenInternotNotConnected != null) {
      //       whenInternotNotConnected();
      //       subcription?.cancel();
      //     } })
      // if (subcription != null) {
      //   subcription = Singleton
      //       .instance.internetConnectivity.checkInternetConnectionStream
      //       .listen((bool isConnectedToInternet) async {
      //     if (isConnectedToInternet) {
      //       if (whenInternotNotConnected != null) {
      //         whenInternotNotConnected();
      //       }
      //       subcription?.cancel();
      //     }
      //   });
      // }
      return {
        "message": "Internet Not Connected",
      };
    }

    return null;
  }
}
