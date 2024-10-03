import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/position_model.dart';
import 'package:nom_du_projet/app/data/models/secteur_model.dart';

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
  void updateVille(String value) {
    villeController.value.text = value;
  }

  void updateSecteur(String value) {
    secteurController.value.text = value;
  }

  void updateaddresse(String value) {
    adresseController.value.text = value;
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
        // change(secteursList, status: RxStatus.success());
      } else {
        // change(null,
        // status: RxStatus.error(
        //     "Une erreur s'produite lors du chargement des données"));
      }
    } catch (e) {
      // change(null,
      //     status: RxStatus.error(
      //         "Une erreur s'produite lors du chargement des données => $e"));
    }
    return positionAddressList;
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
