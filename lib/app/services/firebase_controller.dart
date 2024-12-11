import 'package:get/get.dart';
import 'package:nom_du_projet/app/services/firebase_service.dart';
import 'package:nom_du_projet/app/services/permission_service.dart';

class FirebaseController extends GetxController {
  final firebaseService = FirebaseService();
  final permissionService = PermissionService();

  @override
  void onInit() {
    firebaseService.initLocalNotifications();
    permissionService.handleNotificationPermission();
    firebaseService.setupFirebaseMessaging();
    super.onInit();
  }
}
