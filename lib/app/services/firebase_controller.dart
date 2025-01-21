import 'package:get/get.dart';
import 'package:nom_du_projet/app/services/firebase_service.dart';
import 'package:nom_du_projet/app/services/permission_service.dart';

class FirebaseController extends GetxController {
  final permissionService = PermissionService();
  final firebaseService = FirebaseService();

  @override
  Future<void> onInit() async {
    await permissionService.handleNotificationPermission();
    firebaseService.initLocalNotifications();
    firebaseService.setupFirebaseMessaging();
    super.onInit();
  }
}
