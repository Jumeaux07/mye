import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';

import '../../../data/get_data.dart';

class HomeController extends GetxController with StateMixin<dynamic> {
  //TODO: Implement HomeController

  final _dataProvider = GetDataProvider();
  final userList = <UserModel>[].obs;

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

  @override
  void onInit() {
    super.onInit();
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
