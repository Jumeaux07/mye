import 'package:get/get.dart';

import '../controllers/cinetpay_controller.dart';

class CinetpayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CinetpayController>(
      () => CinetpayController(),
    );
  }
}
