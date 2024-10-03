import 'package:get/get.dart';

import '../controllers/interrestprofil_controller.dart';

class InterrestprofilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InterrestprofilController>(
      () => InterrestprofilController(),
    );
  }
}
