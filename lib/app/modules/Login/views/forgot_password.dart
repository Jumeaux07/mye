import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/register/controllers/register_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/customAppBar.dart';

import '../../../widgets/customEmailTextField.dart';
import '../../../widgets/customPasswordTextField.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../controllers/login_controller.dart';

class ForgotPassword extends GetView<RegisterController> {
  const ForgotPassword({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(RegisterController());
    return Obx(() => Scaffold(
          body: SafeArea(
              child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              Customappbar(),
              SizedBox(
                height: 60,
              ),

              //TextFieldclogin

              Form(
                key: controller.formKeyForgotpassword.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image
                    Image.asset(
                      "${!Get.isDarkMode ? "assets/images/LOGO-MYE-Dark.png" : "assets/images/LOGO-MYE-Ligth.png"}",
                      height: 70,
                      width: 70,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    //Title Form
                    Text(
                      "Mot de passe oublié",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    //Input Email
                    Customemailtextfield(
                      emailController: controller.emailController.value,
                      labal: "Email",
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),

              //button
              GoldButtonLight(
                onTap: () {
                  if (controller.formKeyForgotpassword.value.currentState!
                          .validate() &&
                      controller.emailController.value.text.isNotEmpty) {
                    controller.resetpasswordrequest(
                        controller.emailController.value.text);
                  }
                },
                isLoading: controller.loadingRegister.value,
                label: 'Valider',
              ),
              SizedBox(
                height: 15,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: Text(
                      "Se connecter",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              )
            ],
          )),
        ));
  }
}
