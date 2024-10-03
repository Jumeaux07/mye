import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/widgets/intro3.dart';

import '../../../widgets/intro.dart';
import '../../../widgets/intro2.dart';

class MainIntroController extends GetxController {
  // Le contrôleur de la page pour la vue de l'introduction
  final pageController = PageController(initialPage: 0).obs;
  var pageactivePage = 0.obs; // Page active
  RxList<Widget> intropages = [
    const Intro(),
    const Intro2(),
    const Intro3(),
  ].obs;

  List<Container> getIntroPage() {
    return [
      Container(
        height: Get.height * 0.30,
        child: Image.asset(
          "assets/images/intro1.png",
          fit: BoxFit.contain,
        ),
      ),
      Container(
        height: Get.height * 0.30,
        child: Image.asset(
          "assets/images/intro2.png",
          fit: BoxFit.contain,
        ),
      ),
      Container(
        height: Get.height * 0.30,
        child: Image.asset(
          "assets/images/intro3.png",
          fit: BoxFit.contain,
        ),
      ),
    ];
  }

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    // Timer pour changer la page automatiquement toutes les 3 secondes
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (pageactivePage.value < intropages.length - 1) {
        pageactivePage.value++;
      } else {
        pageactivePage.value = 0;
      }

      // Animation de la pagination
      pageController.value.animateToPage(
        pageactivePage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void onClose() {
    // Nettoyage
    pageController.value.dispose();
    timer?.cancel();
    super.onClose();
  }
}
