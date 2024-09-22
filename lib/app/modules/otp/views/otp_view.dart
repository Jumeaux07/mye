import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../data/constant.dart';
import '../../../widgets/customAppBar.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  OtpView(this.email, this.password, this.passwordConfirmation, {super.key});

  final String? email;
  final String? password;
  final String? passwordConfirmation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: controller.formKey.value,
            child: Column(
              children: [
                Customappbar(),
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Nous vous avons envoyé le code OTP par email ",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 60,
                ),
                Directionality(
                  // Specify direction if desired
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    // You can pass your own SmsRetriever implementation based on any package
                    // in this example we are using the SmartAuth

                    controller: controller.pinController.value,
                    focusNode: controller.focusNode.value,
                    defaultPinTheme: defaultPinTheme,
                    separatorBuilder: (index) => const SizedBox(width: 20),
                    // validator: (value) {
                    //   return value == '2222' ? null : 'Code invalide';
                    // },
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () {
                    controller.focusNode.value.unfocus();
                    controller.formKey.value.currentState!.validate();
                  },
                  child: GoldButtonLight(
                      isLoading: controller.isLoadingOtp.value,
                      label: 'Valider',
                      onTap: () {
                        controller.verifyOtpCode(
                            email ?? "",
                            controller.pinController.value.text,
                            password ?? "",
                            passwordConfirmation ?? "");
                      }),
                ),
                InkWell(
                  onTap: () => controller.verifyOtpCode(
                      email ?? "",
                      controller.pinController.value.text,
                      password ?? "",
                      passwordConfirmation ?? ""),
                  child: Text(
                    "Renvoyer le code?",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w100,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
