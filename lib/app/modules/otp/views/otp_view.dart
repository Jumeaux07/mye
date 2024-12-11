import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:pinput/pinput.dart';

import '../../../data/constant.dart';
import '../../../widgets/customAppBar.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../../register/controllers/register_controller.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  OtpView(this.email, this.password, this.passwordConfirmation, {super.key});

  final String? email;
  final String? password;
  final String? passwordConfirmation;

  final registerController = Get.find<RegisterController>();
  final profileRegisterController = Get.find<ProfileregisterController>();

  @override
  Widget build(BuildContext context) {
    Get.put(OtpController());

    // Assurez-vous que chaque formKey est unique
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey, // Utilisez une clé unique ici
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
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        controller: controller.pinController.value,
                        focusNode: controller.focusNode.value,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 20),
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
                        formKey.currentState!
                            .validate(); // Utilisez la clé unique ici
                      },
                      child: GoldButtonLight(
                          isLoading: controller.isLoadingOtp.value,
                          label: 'Valider',
                          onTap: () {
                            controller.verifyOtpCode(
                                email ?? "",
                                controller.pinController.value.text,
                                password ?? "",
                                passwordConfirmation ?? "",
                                profileRegisterController
                                    .secteurController.value.text);
                          }),
                    ),
                    InkWell(
                      onTap: () => registerController.reSendOtpUser(
                          registerController.pseudoController.value.text,
                          registerController.emailController.value.text,
                          registerController.passwordController.value.text,
                          registerController
                              .passwordConfirmationController.value.text),
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
        ));
  }
}
