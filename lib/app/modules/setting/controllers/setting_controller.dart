import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/factures.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';

import '../../../services/theme_service.dart';

class SettingController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement SettingController
  // États pour les différents paramètres
  final notificationsEnabled = true.obs;
  final emailNotifications = true.obs;
  final darkMode = false.obs;
  final locationEnabled = true.obs;
  final selectedLanguage = 'Français'.obs;
  final isLoading = false.obs;

  final factures = <FactureModel>[].obs;

  final lastPasswordController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final passwordConfirmationController = TextEditingController().obs;

  final userrr = UserModel().obs;

  final _getData = GetDataProvider();

  // Options de langue disponibles
  final List<String> languages =
      ['Français', 'English', 'Español', 'Deutsch'].obs;

  void setLanguage(String value) {
    selectedLanguage.value = value;
  }

  void setNotificationsEnabled(bool value) {
    notificationsEnabled.value = value;
  }

  void setEmailNotifications(bool value) {
    emailNotifications.value = value;
  }

  void setDarkMode(bool value) {
    ThemeService.switchTheme();
    darkMode.value = Get.isDarkMode ? false : true;
  }

  void setLocationEnabled(bool value) {
    locationEnabled.value = value;
  }

  void getFactures() async {
    await Future.delayed(Duration(milliseconds: 100));
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.getFactures();
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        factures.value = (response.body["facture"] as List)
            .map((el) => FactureModel.fromJson(el))
            .toList();

        print("********************** ${factures} ***************************");
        update();
        // ScaffoldMessenger.of(Get.context!)
        //     .showSnackBar(SnackBar(content: Text("Demande envoyée")));
        change(factures, status: RxStatus.success());
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
                "Une erreur s'est produite lors de la récupreation des factures ${response.statusCode}")));
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de l'envoi de récupreation des factures ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de l'envoi de récupreation des factures => $e"));
    }
  }

  Future<void> updatePassword(
    String lastPassword,
    String password,
  ) async {
    try {
      isLoading(true);
      final response = await _getData.updatePassword(lastPassword, password);
      if (response.statusCode == 200) {
        //Vider les valeurs saisies
        lastPasswordController.value.clear();
        passwordController.value.clear();
        passwordConfirmationController.value.clear();
        Get.dialog(CustomAlertDialog(
            success: true,
            message: "${response.body["message"]}",
            onPressed: () {
              Get.back();
              Get.back();
            },
            showAlertIcon: true));

        isLoading(false);
      } else {
        Get.dialog(CustomAlertDialog(
            success: false,
            message: "${response.body["message"]}",
            onPressed: () {
              Get.back();
            },
            showAlertIcon: true));
        isLoading(false);
      }
    } catch (e) {
      Get.dialog(CustomAlertDialog(
          success: false,
          message: "$e",
          onPressed: () {
            Get.back();
          },
          showAlertIcon: true));
    }
  }

  @override
  void onInit() {
    super.onInit();
    getFactures();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
