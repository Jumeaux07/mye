import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/middleware/auth_middleware.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final formKey = GlobalKey<FormState>().obs;
  final formKeyForgotpassword = GlobalKey<FormState>().obs;
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

  Future<void> login(String vemail, String vpassword) async {
    final isConnected = await contectivityController.checkInternet();
    if (!isConnected) {
      final error = "Vérifier votre connexion internet";
      showDialog(
          context: Get.context!,
          builder: (_) => CustomAlertDialog(
              showAlertIcon: true,
              message: error,
              onPressed: () => Get.back()));
      return;
    }
    isLoginLaoding.value = true;
    var data = {"email": vemail, "password": vpassword};
    final response = await _authProvider.login(data);

    if (response.statusCode == 200) {
      await box.write("token", "${response.body["token"]}");
      Env.usertoken = response.body["token"];
      Env.userAuth = UserModel.fromJson(response.body["user"]);

      await FirebaseMessaging.instance.getToken().then((value) {
        box.write("fcm_token", value);
        _authProvider.updateFcmToken(value ?? "");
      });

      // _authProvider.updateFcmToken("${box.read("fcm_token")}");
      email.value.clear();
      password.value.clear();
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
