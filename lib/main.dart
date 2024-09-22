import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/modules/otp/controllers/otp_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(fontFamily: "Poppins", colorSchemeSeed: Color(0xFFCBA948)),
      title: "Mye",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(OtpController());
      }),
    ),
  );
}
