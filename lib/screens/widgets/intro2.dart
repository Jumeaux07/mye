import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Intro2 extends StatelessWidget {
  const Intro2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.30,
      child: Image.asset(
        "assets/images/intro2.png",
        fit: BoxFit.contain,
      ),
    );
  }
}
