import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.30,
      child: Image.asset(
        "assets/images/intro1.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
