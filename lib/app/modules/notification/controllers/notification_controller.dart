import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/notification_model.dart';

import '../../../data/constant.dart';

class NotificationController extends GetxController with StateMixin<dynamic> {
  final _getData = GetDataProvider();
  final listNotification = <NotificationModel>[].obs;
  final totalNotifcation = 0.obs;

  Future<void> getAllNotification() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.getAllNotification();

      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        final list = (response.body['notifications'] as List);
        totalNotifcation.value = response.body['total'];
        listNotification.value =
            list.map((e) => NotificationModel.fromJson(e)).toList();
        Env.notificationnCount = totalNotifcation.value;
        update();

        change(listNotification, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors du chargement de données ${response.body}"));
      }
    } catch (e) {
      print(
          "Une erreur s'est produite lors du chargement de données  => ${e.toString()}");

      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors du chargement de données  => ${e.toString()}"));
    }
  }

  Future<void> readNotification(String id) async {
    // change(null, status: RxStatus.loading());
    try {
      final response = await _getData.readNotification(id);

      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        // change(null, status: RxStatus.success());
        await getAllNotification();
        update();
      } else {
        // change(null,
        // status: RxStatus.error("Erreur : ${response.body['message']}"));
      }
    } catch (e) {
      change(null, status: RxStatus.error("Erreur : ${e.toString()}}"));
    }
  }

  Future<void> readAllNotification() async {
    // change(null, status: RxStatus.loading());
    try {
      final response = await _getData.readAllNotification();

      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        // change(null, status: RxStatus.success());
        await getAllNotification();
        update();
      } else {
        // change(null,
        //     status: RxStatus.error("Erreur : ${response.body['message']}"));
      }
    } catch (e) {
      // change(null, status: RxStatus.error("Erreur : ${e.toString()}}"));
    }
  }

  Future<void> deleteNotification(String id) async {
    // change(null, status: RxStatus.loading());
    try {
      final response = await _getData.deleteNotification(id);

      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        // change(null, status: RxStatus.success());
        await getAllNotification();
        update();
      } else {
        // change(null,
        //     status: RxStatus.error("Erreur : ${response.body['message']}"));
      }
    } catch (e) {
      // change(null, status: RxStatus.error("Erreur : ${e.toString()}}"));
    }
  }

  Future<void> deleteAllNotification() async {
    // change(null, status: RxStatus.loading());
    try {
      final response = await _getData.deleteAllNotification();

      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        // change(null, status: RxStatus.success());
        await getAllNotification();
        update();
      } else {
        // change(null,
        //     status: RxStatus.error("Erreur : ${response.body['message']}"));
      }
    } catch (e) {
      // change(null, status: RxStatus.error("Erreur : ${e.toString()}}"));
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (box.hasData("token")) {
      getAllNotification();
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
}
