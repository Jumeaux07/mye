import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/discussioncontroller.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/modules/messagerie/controllers/messagerie_controller.dart';
import 'package:nom_du_projet/app/modules/splashscreen/controllers/splashscreen_controller.dart';
import 'package:nom_du_projet/app/services/firebase_controller.dart';

import 'app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'app/modules/abonnement/controllers/abonnement_controller.dart';
import 'app/modules/otp/controllers/otp_controller.dart';
import 'app/modules/profile_detail/controllers/profile_detail_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/routes/app_pages.dart';
import 'app/services/theme_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  initializeDateFormatting('fr_FR', null);
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
      theme: ThemeService.lightTheme,
      darkTheme: ThemeService.darkTheme,
      themeMode:
          ThemeService.loadThemeData() ? ThemeMode.dark : ThemeMode.light,
      title: "Mye",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: BindingsBuilder(() {
         Get.put(HomeController());
        Get.put(SplashscreenController());
        Get.put(ProfileregisterController());
        Get.put(AbonnementController());
        Get.put(ProfileDetailController());
        Get.put(DiscussionsController());
         Get.put(MessagerieController());
        Get.lazyPut(() => OtpController());
        Get.put(FirebaseController());
      }),
    ),
  );
}
