import 'dart:developer';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
  }

  Future<Response> updateFcmToken(String fcm_token) async {
    final url = baseUrl + updateFcmTokenUrl;
    var body = {"fcm_token": fcm_token};
    Response response;

    try {
      response = await post(
          url, headers: {"Authorization": "Bearer ${Env.usertoken}"}, body);
      if (response.isOk) {
        log("Mise a jour du token de l'utilisateur: ${response.body}");
      } else {
        log("Erreur lors de la mise a jour du tokende l'utilisateur: ${response.body}");
      }
    } catch (e) {
      log("Exception lors de la mise a jour du tokende l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jour du token de l'
              'utilisateur');
    }
    return response;
  }

  Future<Response> sendOtpRegister(Map<String, dynamic> data) async {
    final response = await post(baseUrl + registerUrl, data);
    return response;
  }

  Future<Response> verifyOtpCode(Map<String, dynamic> data) async {
    final response = await post(baseUrl + verifyOtpCodeUrl, data);
    return response;
  }

  Future<Response> login(Map<String, dynamic> data) async {
    final response = await post(baseUrl + loginUrl, data);
    log("Token ${response.body['token']}");
    log("Message ${response.body['message']}");
    log("User ${response.body['user']}");
    log("is active ${response.body['is_active']}");
    return response;
  }

  //Login with google
}
