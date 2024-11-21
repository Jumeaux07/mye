import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/constant.dart';
import '../../../widgets/custom_alert.dart';
import '../controllers/cinetpay_controller.dart';

class CinetpayView extends GetView<CinetpayController> {
  const CinetpayView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CinetPayCheckout(
          title: 'PAIEMENT DE L\'ABONNEMENT',
          titleStyle: TextStyle(fontSize: 19),
          // titleBackgroundColor: YOUR_TITLE_BACKGROUND_COLOR,
          configData: <String, dynamic>{
            'apikey': API_KEY,
            'site_id': SITE_ID,
            'notify_url': 'https://mye.franckprod.com/api/get-all-secteurs'
          },
          paymentData: <String, dynamic>{
            'transaction_id': 'YOUR_TRANSACTION_ID',
            'amount': 100,
            'currency': 'XOF',
            'channels': 'ALL',
            'description': 'YOUR_DESCRIPTION'
          },
          waitResponse: (response) {
            print(response);
          },
          onError: (error) {
            Get.dialog(CustomAlertDialog(
                message: "$error",
                onPressed: () {
                  Get.back();
                },
                showAlertIcon: true));
            print(error);
          }),
    );
  }
}
