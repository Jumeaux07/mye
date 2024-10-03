import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/Login/views/login_view.dart';
import 'package:nom_du_projet/app/modules/register/views/register_view.dart';
import '../../../widgets/bouttongoogle.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../controllers/main_intro_controller.dart';

class MainIntroView extends GetView<MainIntroController> {
  const MainIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Logo
                  Image.asset(
                    "assets/images/LOGO-MYE-Ligth.png",
                    width: Get.width * 0.45,
                  ),
                  // PageView Introduction
                  Container(
                    height: Get.height * 0.30,
                    child: PageView.builder(
                      onPageChanged: (int page) {
                        controller.pageactivePage.value = page;
                      },
                      controller: controller
                          .pageController.value, // Utilisation du contrôleur
                      itemCount: controller.getIntroPage().length,
                      itemBuilder: (BuildContext context, int index) {
                        return controller.getIntroPage()[index];
                      },
                    ),
                  ),
                  // Indicateurs de pagination
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(
                        controller.getIntroPage().length, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            controller.pageController.value.animateToPage(index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear);
                          },
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor:
                                index == controller.pageactivePage.value
                                    ? Color(0xFFCBA948)
                                    : Colors.grey,
                          ),
                        ),
                      );
                    }),
                  ),
                  // Boutons de connexion
                  Column(
                    children: [
                      GoldButtonLight(
                          isLoading: false,
                          label: 'Connexion',
                          onTap: () {
                            box.write("is_first", false);
                            Get.to(() => LoginView());
                          }),
                      SizedBox(height: 15),
                      GoldButtonGoogle(),
                      SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          box.write("is_first", false);
                          Get.to(() => RegisterView());
                        },
                        child: Text(
                          "S'inscrire",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
