import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';

import '../../../data/constant.dart';

class OtpController extends GetxController {
  final pinController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>().obs;
  final focusNode = FocusNode().obs;
  final isLoadingOtp = false.obs;

  final AuthProvider _authProvider = AuthProvider();

  @override
  void onInit() {
    super.onInit();
    formKey.value = GlobalKey<FormState>();
    pinController.value = TextEditingController();
    focusNode.value = FocusNode();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    pinController.value.dispose();
    focusNode.value.dispose();
  }

  Future<void> verifyOtpCode(String email, String otp, String password,
      String passwordConfirmation) async {
    isLoadingOtp(true);
    try {
      var data = {
        "email": email,
        "otp": otp,
        "password": password,
        "password_confirmation": passwordConfirmation
      };
      final response = await _authProvider.verifyOtpCode(data);
      var json = response.body;

      if (response.statusCode == 200) {
        box.write("token", json["token"]);
        showDialog(
            context: Get.context!,
            builder: (_) => CustomAlertDialog(
                  success: true,
                  message: json["message"],
                  onPressed: () {
                    Get.back();
                    Get.offAllNamed('home');
                  },
                  showAlertIcon: true,
                ));
        isLoadingOtp(false);
      } else {
        showDialog(
            context: Get.context!,
            builder: (_) => CustomAlertDialog(
                  message: json["message"].toString(),
                  onPressed: () {
                    Get.back();
                  },
                  showAlertIcon: true,
                ));
        isLoadingOtp(false);
      }
    } catch (e) {
      showDialog(
          context: Get.context!,
          builder: (_) => CustomAlertDialog(
                message: e.toString(),
                onPressed: () {
                  Get.back();
                },
                showAlertIcon: true,
              ));
      isLoadingOtp(false);
    }
  }
}
