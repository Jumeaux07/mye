import 'package:get/get.dart';

import '../controllers/relation_request_controller.dart';

class RelationRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RelationRequestController>(
      () => RelationRequestController(),
    );
  }
}
