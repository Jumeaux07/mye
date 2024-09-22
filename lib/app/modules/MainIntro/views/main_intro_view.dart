import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../widgets/bouttongoogle.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../controllers/main_intro_controller.dart';

class MainIntroView extends GetView<MainIntroController> {
  const MainIntroView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Image View Introduction
              Container(
                height: Get.height * 0.30,
                child: PageView.builder(
                    onPageChanged: (int page) {
                      controller.pageactivePage.value = page;
                    },
                    controller: controller.pageController.value,
                    itemCount: controller.intropages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return controller
                          .intropages[index % controller.intropages.length];
                    }),
              ),
              // Boutton activate
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrer les indicateurs
                children: List<Widget>.generate(controller.intropages.length,
                    (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        controller.pageController.value.animateToPage(index,
                            duration: Duration(seconds: 3),
                            curve: Curves.linear);
                      },
                      child: CircleAvatar(
                        radius: 5, // Ajuster la taille de l'indicateur
                        backgroundColor: index ==
                                controller.pageactivePage.value
                            ? Color(0xFFCBA948)
                            : Colors
                                .grey, // Modifier la couleur pour plus de clarté
                      ),
                    ),
                  );
                }),
              ),
              // Button connexion
              Column(
                children: [
                  GoldButtonLight(
                    isLoading: false,
                    label: 'Connexion',
                    onTap: () => Get.to(() => null),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GoldButtonGoogle(),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () => Get.toNamed('register'),
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
    );
  }
}
