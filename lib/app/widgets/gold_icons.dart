import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoldIcons extends StatelessWidget {
  const GoldIcons({
    super.key,
    this.size,
    this.icon,
  });
  final double? size;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Get.isDarkMode
        ? ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.13,
                  0.25,
                  0.50,
                  1.0
                ],
                colors: [
                  Color(0xFFCBA948),
                  Color(0xFFE9CB68),
                  Color(0xFFE6C25F),
                  Color(0xFFEDC967),
                ]).createShader(bounds),
            child: Icon(
              icon,
              size: size ?? 35,
            ),
          )
        : ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.13,
                  0.25,
                  0.50,
                  1.0
                ],
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 21, 16, 1),
                  Color.fromARGB(255, 55, 42, 6),
                  Color.fromARGB(255, 97, 75, 15),
                ]).createShader(bounds),
            child: Icon(
              icon,
              size: size ?? 35,
            ),
          );
  }
}
