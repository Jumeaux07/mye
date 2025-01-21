import 'package:get/get.dart';

import '../controllers/offline_controller.dart';

class OfflineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflineController>(
      () => OfflineController(),
    );
  }
}
