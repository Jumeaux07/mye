import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';

class ProfileDetailController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement ProfileDetailController

  final _getData = GetDataProvider();
  final user = UserModel().obs;
  final profilreregisterController = Get.put(ProfileregisterController());
  final tags = <String>[].obs;

  void updateTags(String value) {
    tags.add(value);
    update();
  }

  Future<void> updateSkill() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _getData.updateSkill(tags.join(','));

      if (response.statusCode == 200) {
        change(user, status: RxStatus.success());
        await showUser("${box.read("user_id_show")}");
        update();
        Get.back();
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de la mise à jour des données"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de la  mise à jour  des données => $e"));
    }
  }

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
                "Une erreur s'est produite lors de la mise à jour des données"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors la mise à jour des données => $e"));
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
                "Une erreur s'est produite lors du chargement des données"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors du chargement des données => $e"));
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
