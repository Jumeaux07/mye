import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/otp/views/otp_view.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';

import '../../../data/models/user_model.dart';

class RegisterController extends GetxController with StateMixin {
  //TODO: Implement RegisterController

  final pseudoController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final passwordConfirmationController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>().obs;

  final RxBool loadingRegister = false.obs;

  final AuthProvider _authProvider = AuthProvider();

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

  Future<void> sendOtpUser(String pseudo, String email, String password,
      String passwordConfirmation) async {
    loadingRegister(true);
    try {
      var data = {
        "pseudo": pseudo,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
      final response = await _authProvider.sendOtpRegister(data);

      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(response.body["user"]);
        await box.write("token", response.body["user"].toString());
        await box.write("is_active", userModel.isActive);
        showDialog(
            context: Get.context!,
            builder: (_) => CustomAlertDialog(
                success: true,
                message: response.body["message"].toString(),
                onPressed: () {
                  Get.back();
                  Get.to(() => OtpView(email, password, passwordConfirmation));
                },
                showAlertIcon: true));
        loadingRegister(false);
      } else {
        showDialog(
            context: Get.context!,
            builder: (_) => CustomAlertDialog(
                btnLabel: "Continuer",
                message: response.body["error"].toString(),
                onPressed: () {
                  Get.back();
                },
                showAlertIcon: true));
        loadingRegister(false);
      }
    } catch (e) {
      loadingRegister(false);
      print(e);
    }
  }
}
