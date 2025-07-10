import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/register/controllers/register_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/customAppBar.dart';
import 'package:nom_du_projet/app/widgets/customPasswordTextField.dart';

import '../../../widgets/goldbuttonlight.dart';

class Updatepassword extends GetView<RegisterController> {
  const Updatepassword({super.key});
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
                key: controller.formKeynewPassword.value,
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
                      "Nouveau mot de passe",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),
                    //Input passwod
                    Custompasswordtextfield(
                      passwordController: controller.passwordController.value,
                      label: "Mot de passe",
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
                  print("object");
                  controller
                      .resetpassword(controller.passwordController.value.text);
                },
                isLoading: controller.loadingRegister.value,
                label: 'Valider',
              ),
              SizedBox(
                height: 15,
              ),
            ],
          )),
        ));
  }
}
