import 'package:get/get.dart';

import '../controllers/profileregister_controller.dart';

class ProfileregisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileregisterController>(
      () => ProfileregisterController(),
    );
  }
}
