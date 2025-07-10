import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/secteur_model.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/controllers/relation_request_controller.dart';
import 'package:nom_du_projet/app/widgets/detailspageother.dart';

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';

class ProfileDetailController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement ProfileDetailController

  final _getData = GetDataProvider();
  final user = UserModel().obs;
  final userOther = UserModel().obs;
  final bio = TextEditingController().obs;
  final poste = TextEditingController().obs;
  final centreIntert = <String>[].obs;
  final entreprise = TextEditingController().obs;
  final debut = TextEditingController().obs;
  final fin = TextEditingController().obs;
  final profilreregisterController = Get.put(ProfileregisterController());
  final relationController = Get.put(RelationRequestController());
  final tags = <String>[].obs;
  final GetDataProvider _dataProvider = GetDataProvider();
  var isLoading = false.obs;
  var isActive = false.obs;
  var error = Rxn<String>();
  final result = false.obs;

  void updateTags(String value) {
    tags.add(value);
    update();
  }

  void updateposteShoutait(List<String> value) {
    centreIntert.value = value;
    update();
  }

  Future<void> updateSkill() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _getData.updateSkill(Env.skill.join(','));
      if (response.statusCode == 200) {
        Env.userAuth = UserModel.fromJson(response.body['data']);
        change(user, status: RxStatus.success());
        await showUser("${Env.userAuth.id}");
        update();
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

  Future<void> updateCentreInteret() async {
    try {
      change(null, status: RxStatus.loading());
      final response =
          await _getData.updateCentreInteret(centreIntert.join(','));
      if (response.statusCode == 200) {
        Env.userAuth = UserModel.fromJson(response.body['data']);
        change(user, status: RxStatus.success());
        await showUser("${Env.userAuth.id}");
        update();
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

  Future<void> updateBio() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _getData.updateBio(bio.value.text);
      if (response.statusCode == 200) {
        // Env.userAuth = UserModel.fromJson(response.body['data']);
        await showUser("${Env.userAuth.id}");
        change(user, status: RxStatus.success());
        update();
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

  Future<bool> saveSecteur(String secteur) async {
    print("secteur $secteur");
    try {
      change(null, status: RxStatus.loading());
      final response = await _getData.saveSecteur(secteur);
      if (response.statusCode == 201) {
        result.value = true;
        change(user, status: RxStatus.success());
        update();
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
    return result.value;
  }

  Future<void> updateProfile(String nom, String prenom, String secteur,
      String ville, String lon, String lat) async {
    log("lon $lon lat $lat adresse $ville secteur");
    try {
      change(null, status: RxStatus.loading());
      final response =
          await _getData.updateProfile(nom, prenom, secteur, ville, lon, lat);
      if (response.statusCode == 200) {
        // Env.userAuth = UserModel.fromJson(response.body['data']);
        await showUser("${Env.userAuth.id}");
        change(user, status: RxStatus.success());
        update();
        // poste.value.clear();
        // entreprise.value.clear();
        // debut.value.clear();
        // fin.value.clear();
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

  Future<void> updateExperience(String vposte, String ventreprise,
      String vdateDebut, String vdateFin) async {
    log("vposte $vposte ventreprise $ventreprise vdateDebut ${convertToLaravelDate(vdateDebut)} vdateFin ${convertToLaravelDate(vdateFin)}");
    try {
      change(null, status: RxStatus.loading());
      final response = await _getData.updateExperience(
          vposte, ventreprise, vdateDebut, vdateFin);

      if (response.statusCode == 200) {
        // Env.userAuth = UserModel.fromJson(response.body['data']);ß
        poste.value.clear();
        entreprise.value.clear();
        debut.value.clear();
        fin.value.clear();
        Get.back();
        await showUser("${Env.userAuth.id}");
        change(user, status: RxStatus.success());
        update();
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

  Future<void> updateImageProfile(String image) async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _getData.updateImageProfile(image);

      if (response.statusCode == 200) {
        Env.userAuth = UserModel.fromJson(response.body['data']);
        change(user, status: RxStatus.success());
        Get.back();
        await showUser("${Env.userAuth.id}");
        update();
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
      isLoading.value = true;
      final response = await _getData.showUser(id);

      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.body['data']);
        Env.userAuth = UserModel.fromJson(response.body['data']);
        isActive.value = user.value.isActive == 1 ? true : false;
        Get.offNamed(Routes.PROFILE_DETAIL);
        isLoading.value = false;
      } else {
        error.value =
            "Une erreur s'est produite lors de la récuperation des données ${response.body['data']}";
        isLoading.value = false;
      }
    } catch (e) {
      error.value =
          "Une erreur s'est produite lors la récuperation des données  des données => $e";
      isLoading.value = false;
    }
  }

  Future<void> deleteAbonnement(id) async {
    try {
      isLoading.value = true;
      final response = await _getData.deleteConnection(
        id,
      );

      if (response.statusCode == 200) {
        relationController.getRequest();
        Get.back();
        // Get.offNamed(Routes.PROFILE_DETAIL);
        isLoading.value = false;
      } else {
        error.value =
            "Une erreur s'est produite lors de la récuperation des données ${response.body['data']}";
        isLoading.value = false;
      }
    } catch (e) {
      error.value =
          "Une erreur s'est produite lors la récuperation des données  des données => $e";
      isLoading.value = false;
    }
  }

  Future<void> showUserOther(String id) async {
    try {
      isLoading.value = true;
      final response = await _getData.showUser(id);

      if (response.statusCode == 200) {
        userOther.value = UserModel.fromJson(response.body['data']);
        Env.userOther = UserModel.fromJson(response.body['data']);
        Get.to(() => Detailspageother());
        isLoading.value = false;
      } else {
        error.value =
            "Une erreur s'est produite lors de la récuperation des données ${response.body['data']}";
        isLoading.value = false;
      }
    } catch (e) {
      error.value =
          "Une erreur s'est produite lors la récuperation des données  des données => $e";
      isLoading.value = false;
    }
  }

  Future<void> showUserToEdit(String id) async {
    try {
      box.write('${Env.userAuth.id}', id);
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
