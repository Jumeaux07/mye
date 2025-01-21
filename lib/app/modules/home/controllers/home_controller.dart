import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/data/models/pub_model.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';

import '../../../data/constant.dart';
import '../../../data/get_data.dart';

class HomeController extends GetxController
    with StateMixin<dynamic>, GetSingleTickerProviderStateMixin {
  //TODO: Implement HomeController

  final _dataProvider = GetDataProvider();
  final _authProvider = AuthProvider();
  final userList = <UserModel>[].obs;
  final pubList = <PubModel>[].obs;
  final user = UserModel().obs;
  late AnimationController _animationController;
  late Animation<double> _animation;

  var selectedPlan = ''.obs;
  var isLoading = false.obs;

  void selectPlan(String plan) {
    selectedPlan.value = plan;
  }

  Future<void> subscribe() async {
    isLoading.value = true;
    try {
      // Simuler un appel API
      await Future.delayed(Duration(seconds: 2));
      Get.back(result: selectedPlan.value);
      Get.snackbar(
        'Succès',
        'Abonnement réussi au plan ${selectedPlan.value}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de l\'abonnement',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllUser() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _dataProvider.getAllUser();
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        List list = response.body['data'];
        userList.value = list.map((user) => UserModel.fromJson(user)).toList();
        change(userList, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'produite lors du chargement des données ${response.body['data']}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'produite lors du chargement des données => $e"));
    }
  }

  Future<void> getAuthUser() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _dataProvider.getMe();

      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.body['data']);
        Env.userAuth = UserModel.fromJson(response.body['data']);
        // Env.usertoken = response.body['token'];
        Env.skill = response.body['data']['skill'].toString().split(',');

        log("${Env.userAuth.toJson()}");
        change(user, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'produite lors du chargement des données ${response.body['message']}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'produite lors du chargement des données => $e"));
    }
  }

  Future<void> getPub() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _dataProvider.getPub();
      log(response.statusCode.toString());
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        log(response.statusCode.toString());
        pubList.value = (response.body['data'] as List)
            .map((el) => PubModel.fromJson(el))
            .toList();

        change(pubList, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'produite lors du chargement des données ${response.body['message']}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'produite lors du chargement des données => $e"));
    }
  }

  Future<void> search(String query) async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _dataProvider.search(query);
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        List list = response.body['data'];
        userList.value = list.map((user) => UserModel.fromJson(user)).toList();
        change(userList, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'produite lors du chargement des données ${response.body['data']}"));
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
    super.onInit();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0.0, end: 2.0).animate(_animationController);
    // if(box.hasData("token")){
    //    getAuthUser();
    //    getAllUser();
    // }

    getAuthUser();
    getAllUser();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
  }

  Animation<double> get animation => _animation;
  RxInt selectedIndex = 0.obs;

  void navigate(int index) {
    selectedIndex.value = index;
  }
}
