import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/widgets/intro3.dart';

import '../../../widgets/intro.dart';
import '../../../widgets/intro2.dart';

class MainIntroController extends GetxController {
  //TODO: Implement MainIntroController

  final count = 0.obs;
  final pageController = PageController(initialPage: 0).obs;
  var pageactivePage = 0.obs;
  RxList<Widget> intropages = [
    const Intro(),
    const Intro2(),
    const Intro3(),
  ].obs;

  Timer? timer;
  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (pageactivePage < intropages.length) {
        pageactivePage++;
      } else {
        pageactivePage.value = 0;
      }

      pageController.value.animateToPage(
        pageactivePage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    pageController.value.dispose();
    timer?.cancel();
  }
}
