import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';

import '../../../widgets/CustomTextField.dart';
import '../../../widgets/customAppBar.dart';
import '../../../widgets/customEmailTextField.dart';
import '../../../widgets/customPasswordTextField.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
              child: ListView(
            padding: EdgeInsets.all(16),
            children: [
              //Appbar
              Customappbar(),
              SizedBox(
                height: 60,
              ),
              //TextField register
              Container(
                child: Form(
                    key: controller.formKey.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title Form
                        Text(
                          "Identifiants",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        //Pusedo
                        Customtextfield(
                            textController: controller.pseudoController.value,
                            label: 'Pseudo'),
                        SizedBox(
                          height: 15,
                        ),
                        Customemailtextfield(
                            emailController: controller.emailController.value,
                            labal: 'Email'),
                        SizedBox(
                          height: 15,
                        ),
                        Custompasswordtextfield(
                            passwordController:
                                controller.passwordController.value,
                            label: 'Mot de passe'),
                        SizedBox(
                          height: 15,
                        ),
                        Custompasswordtextfield(
                            validator: (value) {
                              if (controller.passwordConfirmationController
                                      .value.text !=
                                  value) {
                                return "Les mots de passe ne correspondent pas";
                              }
                              return null;
                            },
                            passwordController:
                                controller.passwordConfirmationController.value,
                            label: 'Confirmation'),

                        SizedBox(
                          height: 15,
                        ),
                        GoldButtonLight(
                          isLoading: controller.loadingRegister.value,
                          label: "S'inscrire",
                          onTap: () {
                            controller.sendOtpUser(
                                controller.pseudoController.value.text,
                                controller.emailController.value.text,
                                controller.passwordController.value.text,
                                controller
                                    .passwordConfirmationController.value.text);
                          },
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        InkWell(
                          onTap: () => Get.offAllNamed(Routes.LOGIN),
                          child: Center(
                            child: Text(
                              "Se connecter",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          )),
        ));
  }
}
