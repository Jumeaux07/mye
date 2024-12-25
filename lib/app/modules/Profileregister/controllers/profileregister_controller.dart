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
  final ville = "".obs;
  final activite = "".obs;
  final adresseController = TextEditingController().obs;
  final secteurController = TextEditingController().obs;
  final competenceController = TextEditingController().obs;
  final bioController = TextEditingController().obs;
  final query = TextEditingController().obs;
  final RxList<String> skills = <String>[].obs;
  final skillsController = StringTagController().obs;
  final imageEnBase64 = "".obs;
  final isLoading = false.obs;
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
    ville.value = value;
    villeController.value.text = value;
  }

  void updateSecteur(String value) {
    activite.value = value;
    secteurController.value.text = value;
  }

  void updateaddresse(String value) {
    ville.value = value;
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

    Future<void> updateImage() async {
        // return log("$nom $prenom $secteur_activite $adresse_geographique $biographie"); 
    try {
      change(null, status: RxStatus.loading());

      final response = await _dataProvider.updateImageProfile(
          imageEnBase64.value);

      if (response.statusCode == 200) {
        Env.userAuth = UserModel.fromJson(response.body['data']);
        change(null, status: RxStatus.success());
          await ProfileDetailController().showUser("${Env.userAuth.id}}");
        update();
        cleanImagebase64();
        query.value.clear();
      
        await ProfileDetailController()
            .showUser("${Env.userAuth.id}");
        Get.offAllNamed(Routes.HOME);
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite: ${response.body['message'] != null ? response.body['message'] : "Une erreur s'est produite"}"));
      }
    } catch (e) {
      change(null, status: RxStatus.error("Une erreur s'est produitee $e"));
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
