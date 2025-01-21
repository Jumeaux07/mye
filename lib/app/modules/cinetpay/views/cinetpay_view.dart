import 'dart:developer';

import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/constant.dart';
import '../../../widgets/custom_alert.dart';
import '../controllers/cinetpay_controller.dart';

class CinetpayView extends GetView<CinetpayController> {
  CinetpayView(this.montant, this.description, {super.key});
  final double? montant;
  final String? description;
  @override
  Widget build(BuildContext context) {
    log(montant.toString());
    return Scaffold(
      body: CinetPayCheckout(
          title: 'PAIEMENT DE L\'ABONNEMENT',
          titleStyle: TextStyle(fontSize: 19),
          // titleBackgroundColor: YOUR_TITLE_BACKGROUND_COLOR,
          configData: <String, dynamic>{
            'apikey': Env.API_KEY,
            'site_id': Env.SITE_ID,
            'notify_url': 'https://api.franckprod.com/api/notifyurl'
          },
          paymentData: <String, dynamic>{
            'transaction_id': 'YOUR_TRANSACTION_ID',
            'amount': montant ?? 100.0,
            'currency': 'XOF',
            'channels': 'ALL',
            'description': description ?? 'Abonnement premium'
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
