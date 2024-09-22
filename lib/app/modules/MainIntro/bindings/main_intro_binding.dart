import 'package:get/get.dart';

import '../controllers/main_intro_controller.dart';

class MainIntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainIntroController>(
      () => MainIntroController(),
    );
  }
}
