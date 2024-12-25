import 'dart:developer';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';

import '../../../data/constant.dart';
import '../../../data/get_data.dart';

class HomeController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement HomeController

  final _dataProvider = GetDataProvider();
  final userList = <UserModel>[].obs;
  final user = UserModel().obs;

  Future<void> getAllUser() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _dataProvider.getAllUser();
      if (response.statusCode == 200) {
        List list = response.body['data'];
        userList.value = list.map((user) => UserModel.fromJson(user)).toList();
        change(userList, status: RxStatus.success());
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

  Future<void> getAuthUser() async {
    try {
      change(null, status: RxStatus.loading());
      final response = await _dataProvider.getMe();

      if (response.statusCode == 200) {
        user.value = UserModel.fromJson(response.body['data']);
        Env.userAuth = UserModel.fromJson(response.body['data']);
        // Env.usertoken = response.body['token'];
        Env.skill = response.body['data']['skill'].toString().split(',');
    
        log("${Env.userAuth.toJson()}");
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
  }

  RxInt selectedIndex = 0.obs;

  void navigate(int index) {
    selectedIndex.value = index;
  }
}
