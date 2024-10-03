import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nom_du_projet/app/modules/splashscreen/controllers/splashscreen_controller.dart';

import 'app/modules/otp/controllers/otp_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(fontFamily: "Poppins", colorSchemeSeed: Color(0xFFCBA948)),
      title: "Mye",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(SplashscreenController());
        Get.lazyPut(() => OtpController());
      }),
    ),
  );
}
