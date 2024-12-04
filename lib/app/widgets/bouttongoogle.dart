import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoldButtonGoogle extends StatelessWidget {
  GoldButtonGoogle({
    super.key,
    this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 50,
        width: Get.width,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/google.png"),
            SizedBox(
              width: 7,
            ),
            Text(
              "Continuner avec Google",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.transparent,
            border: Border.all(width: 0)),
      ),
    );
  }
}
