import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/cinetpay/views/cinetpay_view.dart';
import 'package:http/http.dart' as http;
import 'package:nom_du_projet/app/services/payement_service.dart';

import '../controllers/abonnement_controller.dart';

class AbonnementView extends GetView<AbonnementController> {
  AbonnementView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getAbonnement();
    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Text('Abonnement'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(
                '${controller.abonnement.value.libelle}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Sélection du nombre de mois
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Durée : '),
                  DropdownButton<int>(
                    value: controller.selectedMonths.value,
                    items: [1, 3, 6, 12].map((int months) {
                      return DropdownMenuItem<int>(
                        value: months,
                        child: Text('$months mois'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        controller.updateSelectedMonths(newValue);
                      }
                    },
                  ),
                ],
              ),

              // Prix total
              Text(
                'Prix total: ${(controller.abonnement.value.price! * controller.selectedMonths.value).toStringAsFixed(2)} EUR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20),

              Obx(() => Column(
                    children: controller.savedPaymentMethods
                        .map((method) => _buildPaymentMethodTile(method))
                        .toList(),
                  )),

              SizedBox(height: 20),

              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: controller.selectedMethod.value == null
                          ? null
                          : () {
                              if (controller.selectedMethod.value?.id == '1') {
                                var url = Uri.parse(
                                    "https://api.franckprod.com/api/get-factures?jours=${controller.selectedMonths.value}");
                                http.get(
                                  url,
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization':
                                        "Bearer ${box.read("token")}"
                                  },
                                ).then((response) {
                                  if (response.statusCode == 201) {
                                    // Traitement des données en cas de succès
                                    final data = jsonDecode(response.body);
                                    print('Données reçues: $data');
                                    // Faites quelque chose avec les données
                                  } else {
                                    // Gestion des erreurs HTTP
                                    print('Erreur: ${response.body}');
                                  }
                                }).catchError((error) {
                                  // Gestion des erreurs de connexion
                                  print('Erreur de connexion: $error');
                                });
                                Get.to(() => CinetpayView(
                                      "Paiement de l'abonnement premium",
                                      genererChaineUnique(),
                                      (controller.abonnement.value.price! *
                                              controller.selectedMonths.value)
                                          .toDouble(),
                                    ));
                                // Get.to(() => CinetpayView(
                                //       "Paiement de l'abonnement premium",
                                //       genererChaineUnique(),
                                //       (controller.abonnement.value.price! *
                                //               controller.selectedMonths.value)
                                //           .toDouble(),
                                //     ));
                              } else {
                                PaymentService.instance.handlePayment(
                                    controller.selectedMonths.value.toString(),
                                    (controller.abonnement.value.price! *
                                        controller.selectedMonths.value),
                                    controller.selectedMethod.value?.name ??
                                        "Carte de crédit");
                              }
                            },
                      child: Text(
                        'Confirmer',
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
              SizedBox(height: 20),
            ],
          ),
        )));
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    return Obx(() => GestureDetector(
          onTap: () => controller.selectMethod(method),
          child: Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: controller.selectedMethod.value?.id == method.id
                    ? Colors.blue
                    : Colors.grey[300]!,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  method.icon,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (method.lastDigits.isNotEmpty)
                        Text(
                          '•••• ${method.lastDigits}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                if (controller.selectedMethod.value?.id == method.id)
                  Icon(Icons.check_circle, color: Colors.blue),
              ],
            ),
          ),
        ));
  }
}
