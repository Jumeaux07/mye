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
                          "Identifiants",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // Type de compte
                        Text(
                          "Type de compte",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    'Particulier',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  value: 'particulier',
                                  groupValue: controller.userType.value,
                                  onChanged: (value) {
                                    controller.userType.value = value!;
                                  },
                                  activeColor: Colors.amber,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 36,
                                color: Colors.grey.shade300,
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text(
                                    'Entreprise',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  value: 'entreprise',
                                  groupValue: controller.userType.value,
                                  onChanged: (value) {
                                    controller.userType.value = value!;
                                  },
                                  activeColor: Colors.amber,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        //Pusedo
                        Customtextfield(
                            textController: controller.pseudoController.value,
                            label: controller.userType.value == 'entreprise'
                                ? 'Nom de l\'entreprise'
                                : 'Pseudo'),
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
                            if (controller
                                    .formKey.value.currentState!
                                    .validate() &&
                                controller
                                    .pseudoController.value.text.isNotEmpty &&
                                controller
                                    .emailController.value.text.isNotEmpty &&
                                controller
                                    .passwordController.value.text.isNotEmpty &&
                                controller.passwordConfirmationController.value
                                    .text.isNotEmpty &&
                                controller.userType.value.isNotEmpty) {
                              controller.sendOtpUser(
                                  controller.pseudoController.value.text,
                                  controller.emailController.value.text,
                                  controller.passwordController.value.text,
                                  controller.passwordConfirmationController
                                      .value.text,
                                  controller.userType.value);
                            }
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
