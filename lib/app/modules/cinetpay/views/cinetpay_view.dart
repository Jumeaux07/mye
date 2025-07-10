import 'dart:developer';

import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';

import '../../../data/constant.dart';
import '../../../widgets/custom_alert.dart';
import '../controllers/cinetpay_controller.dart';

class CinetpayView extends GetView<CinetpayController> {
  CinetpayView(
      this.description, this.transaction_id, this.montant, this.facture_id,
      {super.key});
  final double montant;
  final String? description;
  final String transaction_id;
  final String facture_id;

  double calculateAmount(double value) {
    return value * 655;
  }

  @override
  Widget build(BuildContext context) {
    log(facture_id.toString());
    return Scaffold(
      body: CinetPayCheckout(
          title: 'PAIEMENT DE L\'ABONNEMENT',
          titleStyle: TextStyle(fontSize: 19),
          // titleBackgroundColor: YOUR_TITLE_BACKGROUND_COLOR,
          configData: <String, dynamic>{
            'apikey': Env.API_KEY,
            'site_id': Env.SITE_ID,
            'notify_url': 'https://api.franckprod.com/api/verify-payment'
          },
          paymentData: <String, dynamic>{
            'transaction_id': transaction_id,
            'amount': 100,
            // 'amount': calculateAmount(montant) ?? 100.0,
            'currency': 'XOF',
            'channels': 'ALL',
            'description': description ?? 'Abonnement premium',
            'metadata': facture_id,
          },
          waitResponse: (response) {
            print(response);
            if (response != null && response["code"] == "00") {
              // Paiement réussi

              // Optionnel : tu peux afficher un petit message
              Get.snackbar("Succès", "Paiement effectué avec succès",
                  backgroundColor: Colors.green, colorText: Colors.white);

              // Redirection vers la page d’accueil (ou autre route principale)
              Get.offAllNamed(Routes.HOME);
              // Assure-toi que '/home' existe dans ton GetPage()
            } else {
              // Paiement échoué ou annulé
              Get.dialog(CustomAlertDialog(
                  message: "Paiement non complété",
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  showAlertIcon: true));
            }
          },
          onError: (error) {
            Get.dialog(CustomAlertDialog(
                message: "$error",
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                showAlertIcon: true));
            print(error);
          }),
    );
  }
}
