import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';

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
      box.write("token", response.body["token"]);
      box.write("is_active", response.body["is_active"]);
      user.value = UserModel.fromJson(response.body["user"]);
      isLoginLaoding.value = false;

      if (user.value.isActive == 0) {
        showDialog(
            context: Get.context!,
            builder: (_) => CustomAlertDialog(
                  message: response.body["message"].toString(),
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed(Routes.HOME);
                  },
                  showAlertIcon: false,
                  success: true,
                  btnLabel: "Continuer",
                ));
      } else {
        isLoginLaoding.value = false;
        Get.offAllNamed(Routes.HOME);
      }
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
