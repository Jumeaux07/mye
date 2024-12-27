import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoldButtonLight extends StatelessWidget {
  GoldButtonLight(
      {super.key,
      required this.label,
      this.onTap,
      this.isEnable,
      this.isLoading});
  final String label;
  void Function()? onTap;
  bool? isEnable = true;
  bool? isLoading = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: Get.width,
        child: Center(
            child: isLoading == false
                ? Text(
                    label,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )
                : CircularProgressIndicator(
                    color: Colors.white,
                  )),
        decoration: isEnable == false
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.grey.withOpacity(0.7))
            : BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
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
                    ])),
      ),
    );
  }
}
