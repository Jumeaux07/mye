import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';
import 'package:nom_du_projet/app/widgets/custom_alert_post.dart';

import '../../../data/models/secteur_model.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final formKey = GlobalKey<FormState>().obs;
  final email = TextEditingController().obs;
  final password = TextEditingController().obs;
  final isLoginLaoding = false.obs;
  final AuthProvider _authProvider = AuthProvider();
  final user = UserModel().obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> login(String email, String password) async {
    isLoginLaoding.value = true;
    var data = {"email": email, "password": password};
    final response = await _authProvider.login(data);

    if (response.statusCode == 200) {
      box.write("token", "${response.body["token"]}");
     Env.usertoken = response.body["token"];
      Env.userAuth = UserModel.fromJson(response.body["user"]);
      
      _authProvider.updateFcmToken("${box.read("fcm_token")}");
    
        isLoginLaoding.value = false;
        Get.offAllNamed(Routes.HOME);
      
    } else {
      isLoginLaoding(false);
      showDialog(
          context: Get.context!,
          builder: (_) => CustomAlertDialog(
              message: response.body["message"].toString(),
              onPressed: () {
                Get.back();
              },
              showAlertIcon: true));
    }
  }
}
