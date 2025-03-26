import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/connections_model.dart';
import 'package:nom_du_projet/app/data/models/relation_model.dart';

import '../../../data/models/user_model.dart';

class RelationRequestController extends GetxController
    with StateMixin<dynamic> {
  final _getData = GetDataProvider();
  final requestUser = <RelationModel>[].obs;
  final requestUserSend = <RelationModel>[].obs;
  final connectionUsers = <ConnectionsModel>[].obs;
  final isLoading = false.obs;
  final currentLoadingUserId = 0.obs;

  void sendRequest(String receiverId) async {
    isLoading.value = true;
    currentLoadingUserId.value = int.parse(receiverId);
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.sendRequest(receiverId);
      if (response.statusCode == 204) {
        isLoading.value = false;
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 201) {
        getRequestSend();
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Demande envoyée")));
        isLoading.value = false;
        change(null, status: RxStatus.success());
      } else {
        isLoading.value = false;
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
                "Une erreur s'est produite lors de l'envoi de la demande ${response.statusCode}")));
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de l'envoi de la demande ${response.statusCode}"));
      }
    } catch (e) {
      isLoading.value = false;
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de l'envoi de la demande => $e"));
    }
  }

  void sendResponseRequest(String starus, String idUser) async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.sendResponseRequest(starus, idUser);
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("succès")));

        update();
        change(null, status: RxStatus.success());
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
                "Une erreur s'est produite lors de l'envoi de la reponse ${response.statusCode}")));
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de l'envoi de la reponse ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de l'envoi de la reponse => $e"));
    }
  }

  void getRequest() async {
    await Future.delayed(Duration(milliseconds: 100));
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.getRequest();
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        print("coooole ${response.body["data"]}");
        requestUser.value = (response.body["data"] as List)
            .map((el) => RelationModel.fromJson(el))
            .toList();
        Env.connectionCount = requestUser.length;
        print("cooool ${requestUser}");
        update();
        // ScaffoldMessenger.of(Get.context!)
        //     .showSnackBar(SnackBar(content: Text("Demande envoyée")));
        change(requestUser, status: RxStatus.success());
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
                "Une erreur s'est produite lors de l'envoi de la demande ${response.statusCode}")));
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de l'envoi de la demande ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de l'envoi de la demande => $e"));
    }
  }

  void getRequestSend() async {
    await Future.delayed(Duration(milliseconds: 100));
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.getRequestSend();
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        requestUserSend.value = (response.body["data"] as List)
            .map((el) => RelationModel.fromJson(el))
            .toList();
        Env.connectionCount = requestUserSend.length;
        print("cooool ${requestUserSend}");
        update();
        // ScaffoldMessenger.of(Get.context!)
        //     .showSnackBar(SnackBar(content: Text("Demande envoyée")));
        change(requestUserSend, status: RxStatus.success());
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
                "Une erreur s'est produite lors de l'envoi de la demande envoye ${response.statusCode}")));
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de l'envoi de la demande envoye ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de l'envoi de la demande envoye => $e"));
    }
  }

  void getRelation() async {
    await Future.delayed(Duration(milliseconds: 100));
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.getRelation();
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        print("coooole ${response.body["data"]}");
        connectionUsers.value = (response.body["data"] as List)
            .map((el) => ConnectionsModel.fromJson(el))
            .toList();
        update();
        change(requestUser, status: RxStatus.success());
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text(
                "Une erreur s'est produite lors de recuoeration des connections ${response.statusCode}")));
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de recuoeration des connections ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de recuoeration des connections => $e"));
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (box.hasData("is_first") && box.hasData("token")) {
      getRelation();
      getRequest();
      getRequestSend();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
