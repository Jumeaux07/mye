import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';

class SplashscreenController extends GetxController {
  final splashLoading = true.obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    log('Initialisation du SplashscreenController');

    // Assurez-vous que la clé "is_first" existe et attribuez-la si nécessaire
    bool isFirst = box.read("is_first") ?? true;
    box.write("is_first", isFirst);

    log('is_first: $isFirst');
    log('is_active: ${box.read("is_active")}');

    if (isFirst == false) {
      // Si ce n'est pas la première fois
      if (box.hasData("token")) {
        // Si le token existe
        log('Token trouvé');
        if (box.read("is_active") == 1) {
          // Si l'utilisateur est actif (profil complété)
          log('Utilisateur actif');
          Future.delayed(const Duration(seconds: 5)).then((_) {
            Get.offAllNamed(Routes.HOME);
          });
        } else {
          log('Utilisateur inactif, redirection vers register');
          Future.delayed(const Duration(seconds: 5)).then((_) {
            Get.offAllNamed(Routes.HOME);
          });
        }
      } else {
        log('Token non trouvé, redirection vers login');
        Future.delayed(const Duration(seconds: 5)).then((_) {
          Get.offAllNamed(Routes.LOGIN);
        });
      }
    } else {
      log('Première utilisation, redirection vers l\'introduction');
      Future.delayed(const Duration(seconds: 2)).then((_) {
        Get.offAllNamed(Routes.MAIN_INTRO);
      });
    }
  }
}
