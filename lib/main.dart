import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/splashscreen/controllers/splashscreen_controller.dart';

import 'app/modules/abonnement/controllers/abonnement_controller.dart';
import 'app/modules/otp/controllers/otp_controller.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // Assurez-vous que les widgets Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = PUBLISHABLEKEY;
  await Stripe.instance.applySettings();

  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        Get.put(AbonnementController());
        Get.lazyPut(() => OtpController());
      }),
    ),
  );
}
