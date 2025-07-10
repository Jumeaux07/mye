import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/Login/views/forgot_password.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/customAppBar.dart';

import '../../../widgets/customEmailTextField.dart';
import '../../../widgets/customPasswordTextField.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
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
              Container(
                child: Form(
                  key: controller.formKey.value,
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
                        "Connexion",
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
                        emailController: controller.email.value,
                        labal: "Email",
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      //Inout password
                      Custompasswordtextfield(
                        passwordController: controller.password.value,
                        label: 'Mot de passe',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),

              //button
              GoldButtonLight(
                onTap: () {
                  if (controller.formKey.value.currentState!.validate() &&
                      controller.email.value.text.isNotEmpty &&
                      controller.password.value.text.isNotEmpty) {
                    controller.login(controller.email.value.text,
                        controller.password.value.text);
                  }
                },
                isLoading: controller.isLoginLaoding.value,
                label: 'Connexion',
              ),
              SizedBox(
                height: 15,
              ),
              //Forget password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.offAllNamed(Routes.REGISTER);
                    },
                    child: Text(
                      "S'inscrire",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => ForgotPassword());
                    },
                    child: Text(
                      'Mot de passe oublié?',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ],
              )
            ],
          )),
        ));
  }
}
