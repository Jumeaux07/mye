import 'package:get/get.dart';

import '../controllers/abonnement_controller.dart';

class AbonnementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbonnementController>(
      () => AbonnementController(),
    );
  }
}
