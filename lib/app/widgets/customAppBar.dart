import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Customappbar extends StatelessWidget {
  Customappbar({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return //Appbar auth
        Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: onTap ?? () => Get.back(),
          child: Icon(
            Icons.close,
            size: 40,
          ),
        )
      ],
    );
  }
}
