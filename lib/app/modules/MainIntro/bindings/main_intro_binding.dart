import 'package:get/get.dart';

import '../controllers/main_intro_controller.dart';

class MainIntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainIntroController());
    // Get.lazyPut<MainIntroController>(
    //   () => MainIntroController(),
    // );
  }
}
