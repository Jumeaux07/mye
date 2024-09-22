import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Customappbar extends StatelessWidget {
  const Customappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return //Appbar auth
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          "assets/images/LOGO-MYE-Ligth.png",
          width: 60,
          height: 60,
        ),
        InkWell(
          onTap: () => Get.back(),
          child: Icon(
            Icons.close,
            size: 40,
          ),
        )
      ],
    );
  }
}
