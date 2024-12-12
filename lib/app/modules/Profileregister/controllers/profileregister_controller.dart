import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/position_model.dart';
import 'package:nom_du_projet/app/data/models/secteur_model.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';
import 'package:textfield_tags/textfield_tags.dart';

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';
import '../../../services/image_picker_service.dart';
import '../../../widgets/custom_alert.dart';

class ProfileregisterController extends GetxController
    with StateMixin<dynamic> {
  //TODO: Implement ProfileregisterController
/*
  TextEditingController
*/
  final nomController = TextEditingController().obs;
  final prenomController = TextEditingController().obs;
  final villeController = TextEditingController().obs;
  final adresseController = TextEditingController().obs;
  final secteurController = TextEditingController().obs;
  final competenceController = TextEditingController().obs;
  final bioController = TextEditingController().obs;
  final query = TextEditingController().obs;
  final RxList<String> skills = <String>[].obs;
  final skillsController = StringTagController().obs;
  final imageEnBase64 = "".obs;
  final ImagePickerService _imagePickerService = ImagePickerService();

  final adresse =
      SingleSelectController<PositionModel?>(PositionModel(displayName: ""))
          .obs;

/*
  List
*/
  final secteursList = <SecteurModel>[].obs;
  final positionAddressList = <PositionModel>[].obs;
/*
  String
*/

  final GetDataProvider _dataProvider = GetDataProvider();

  /*
    funtions Heleprs
  */
  void cleanImagebase64() {
    imageEnBase64.value = "";
  }

  void updateImageBase64(String value) {
    imageEnBase64.value = value;
    update();
  }

  void updateVille(String value) {
    villeController.value.text = value;
  }

  void updateSecteur(String value) {
    secteurController.value.text = value;
  }

  void updateaddresse(String value) {
    adresseController.value.text = value;
  }

  Future<void> pickImage() async {
    final base64Image = await _imagePickerService.pickImageAndConvertToBase64();
    log("IMAGE => ${base64Image}");
    if (base64Image != null || base64Image != "") {
      updateImageBase64(base64Image.toString());
    } else {
      updateImageBase64("");
    }
  }

  Future<void> getSecteur() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _dataProvider.getSecteur();

      if (response.statusCode == 200) {
        final List<dynamic> listData = response.body["data"];
        secteursList.value = listData
            .map(
              (e) => SecteurModel.fromJson(e),
            )
            .toList();
        update();
        print("List => ${secteursList}");
        change(secteursList, status: RxStatus.success());
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

  Future<void> updateUser(String? nom, String? prenom, String? secteur_activite,
      String? adresse_geographique, String? biographie) async {
    try {
      change(null, status: RxStatus.loading());

      final response = await _dataProvider.updateUser(
          nom,
          prenom,
          secteur_activite,
          adresse_geographique,
          biographie,
          imageEnBase64.value);

      if (response.statusCode == 200) {
        change(null, status: RxStatus.success());
        update();
        Get.back();
        Get.back();

        nomController.value.clear();
        prenomController.value.clear();
        villeController.value.clear();
        adresseController.value.clear();
        secteurController.value.clear();
        competenceController.value.clear();
        bioController.value.clear();
        cleanImagebase64();
        query.value.clear();
//
        UserModel userModel = UserModel.fromJson(response.body['data']);
        // Get.dialog(CustomAlertDialog(
        //     success: true,
        //     message: response.body['message'],
        //     onPressed: () async {
        //       Get.back();
        //       Get.back();
        //     },
        // showAlertIcon: true));
        await ProfileDetailController()
            .showUser("${box.write("user_id_show", userModel.id.toString())}");
        Get.offAllNamed(Routes.HOME);
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite: ${response.body['message'] != null ? response.body['message'] : "Une erreur s'est produite"}"));
      }
    } catch (e) {
      change(null, status: RxStatus.error("Une erreur s'est produite $e"));
    }
  }

  Future<List<PositionModel>> findPositionAddress(String query) async {
    try {
      // change(null, status: RxStatus.loading());
      final response = await _dataProvider.findPositionAddress(query);

      if (response.statusCode == 200) {
        final List<dynamic> listData = response.body;
        positionAddressList.value = listData
            .map(
              (e) => PositionModel.fromJson(e),
            )
            .toList();
      } else {}
    } catch (e) {}
    return positionAddressList;
  }

  @override
  void onInit() {
    super.onInit();
    getSecteur();
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
