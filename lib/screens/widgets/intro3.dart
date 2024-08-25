import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Intro3 extends StatelessWidget {
  const Intro3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.30,
      child: Image.asset(
        "assets/images/intro3.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
