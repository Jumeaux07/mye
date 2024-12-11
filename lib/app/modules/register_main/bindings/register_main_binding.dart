import 'package:get/get.dart';

import '../controllers/register_main_controller.dart';

class RegisterMainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterMainController>(
      () => RegisterMainController(),
    );
  }
}
