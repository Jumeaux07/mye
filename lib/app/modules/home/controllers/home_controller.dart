import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/data/models/pub_model.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/services/matching_service.dart';
import 'package:http/http.dart' as http;

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

  ProximityService _proximityService = ProximityService();

  var selectedPlan = ''.obs;
  var isLoading = false.obs;

  Timer? _timer;

  void _startLocationUpdates() {
    // Exécuter immédiatement au démarrage
    _updateLocation();

    // Répéter toutes les 10 minutes
    _timer = Timer.periodic(Duration(minutes: 15), (timer) {
      print(
          "************************ Mise a jour de la position ***************");
      _updateLocation();
    });
  }

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
        Env.contreIntert =
            response.body['data']['centre_interet'].toString().split(',');

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

  Future<void> _updateLocation() async {
    if (box.hasData("token")) {
      try {
        // Vérification des permissions
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        // Récupération de la position actuelle
        Position position = await Geolocator.getCurrentPosition();

        var url = Uri.parse(baseUrl + updateProfillUrl);
        var response = await http.post(
          url,
          body: jsonEncode({
            'latitude': position.latitude,
            'longitude': position.longitude,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer ${box.read("token")}",
          },
        );

        log('Réponse reçue: ${response.body}');
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          log('Données reçues: $data');
        } else {
          print('Erreur: ${response.body}');
        }
      } catch (error) {
        print('Erreur de connexion: $error');
      }
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    super.onInit();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _animation =
        Tween<double>(begin: 0.0, end: 2.0).animate(_animationController);
    _proximityService.detectNearbyUsers();
    _startLocationUpdates();
    if (box.hasData("is_first") && box.hasData("token")) {
      getAuthUser();
      getAllUser();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _timer?.cancel();
  }

  Animation<double> get animation => _animation;
  RxInt selectedIndex = 0.obs;

  void navigate(int index) {
    selectedIndex.value = index;
  }
}
