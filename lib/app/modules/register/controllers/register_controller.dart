import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/modules/otp/controllers/otp_controller.dart';
import 'package:nom_du_projet/app/modules/otp/views/otp_view.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';

class RegisterController extends GetxController with StateMixin {
  //TODO: Implement RegisterController

  final pseudoController = TextEditingController().obs;
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final passwordConfirmationController = TextEditingController().obs;
  final formKey = GlobalKey<FormState>().obs;
  final userType = 'particulier'.obs;

  final RxBool loadingRegister = false.obs;

  final otpController = Get.put(OtpController());

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
      String passwordConfirmation, String userType) async {
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
        Get.dialog(CustomAlertDialog(
            success: true,
            message: response.body["message"].toString(),
            onPressed: () {
              Get.back();
              Get.to(() =>
                  OtpView(email, password, passwordConfirmation, userType));
            },
            showAlertIcon: true));
        loadingRegister(false);
      } else {
        Get.dialog(CustomAlertDialog(
            success: false,
            message: response.body["error"].toString(),
            onPressed: () {
              Get.back();
            },
            showAlertIcon: true));
        loadingRegister(false);
      }
    } catch (e) {
      Get.dialog(CustomAlertDialog(
          success: false,
          message: "Une erreur s'est produite",
          onPressed: () {
            Get.back();
          },
          showAlertIcon: true));
      loadingRegister(false);
      print(e);
    }
  }

  Future<void> reSendOtpUser(
    String pseudo,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    otpController.isLoadingOtp.value = true;
    try {
      var data = {
        "pseudo": pseudo,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirmation,
      };
      final response = await _authProvider.sendOtpRegister(data);

      if (response.statusCode == 200) {
        otpController.isLoadingOtp.value = false;
      } else {
        otpController.isLoadingOtp.value = false;
      }
    } catch (e) {
      Get.dialog(CustomAlertDialog(
          success: false,
          message: "${e.toString()}",
          onPressed: () {
            Get.back();
          },
          showAlertIcon: true));
      otpController.isLoadingOtp.value = false;
    }
  }
}
