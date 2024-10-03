import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splashscreen_controller.dart';

class SplashscreenView extends GetView<SplashscreenController> {
  const SplashscreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                    width: 180,
                    height: 187,
                    "assets/images/LOGO-MYE-Ligth.png"),
                SizedBox(
                  height: 70,
                ),
                controller.splashLoading.value
                    ? CircularProgressIndicator()
                    : SizedBox.shrink()
              ],
            ),
          ),
        ));
  }
}
