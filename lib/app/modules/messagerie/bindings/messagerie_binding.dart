import 'package:get/get.dart';

import '../controllers/messagerie_controller.dart';

class MessagerieBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessagerieController>(
      () => MessagerieController(),
    );
  }
}
