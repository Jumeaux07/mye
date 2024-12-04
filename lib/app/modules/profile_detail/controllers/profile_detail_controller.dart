import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/services/image_picker_service.dart';

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';

class ProfileDetailController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement ProfileDetailController

  final _getData = GetDataProvider();
  final user = UserModel().obs;
  final profilreregisterController = Get.put(ProfileregisterController());

  Future<void> showUser(String id) async {
    try {
      box.write('user_id_show', id);
      change(null, status: RxStatus.loading());
      final response = await _getData.showUser(id);

      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.body['data']);
        Get.toNamed(Routes.PROFILE_DETAIL);
        change(user, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'produite lors du chargement des données"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'produite lors du chargement des données => $e"));
    }
  }

  Future<void> showUserToEdit(String id) async {
    try {
      box.write('user_id_show', id);
      change(null, status: RxStatus.loading());
      final response = await _getData.showUser(id);

      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.body['data']);
        Get.toNamed(Routes.PROFILEREGISTER);
        profilreregisterController.nomController.value.text =
            user.value.nom ?? "";
        profilreregisterController.prenomController.value.text =
            user.value.prenom ?? "";
        profilreregisterController.adresseController.value.text =
            user.value.adresseGeographique ?? "";
        profilreregisterController.secteurController.value.text =
            user.value.secteurActivite ?? "";
        profilreregisterController.bioController.value.text =
            user.value.biographie ?? "";

        change(user, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'produite lors du chargement des données"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'produite lors du chargement des données => $e"));
    }
  }

  @override
  void onInit() {
    super.onInit();
    showUser(user.value.id.toString());
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
