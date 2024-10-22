import 'dart:developer';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';

class AuthProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
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
