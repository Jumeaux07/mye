import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/cinetpay/views/cinetpay_view.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
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
              // Barre de drag
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
                '${controller.abonnement.value.libelle} ${controller.abonnement.value.price} FCFA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              ...controller.abonnement.value
                  .getItemList()
                  .map((feature) => Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 8),
                            Text(feature),
                          ],
                        ),
                      )),

              SizedBox(height: 20),

              // Liste des méthodes de paiement sauvegardées
              Obx(() => Column(
                    children: controller.savedPaymentMethods
                        .map((method) => _buildPaymentMethodTile(method))
                        .toList(),
                  )),

              // Bouton pour ajouter une nouvelle carte

              SizedBox(height: 20),

              // Bouton de confirmation
              Obx(() => controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: controller.selectedMethod.value == null
                          ? null
                          : () {
                              if (controller.selectedMethod.value?.id == '1') {
                                Get.to(() => CinetpayView(
                                    controller.abonnement.value.price
                                        ?.toDouble(),
                                    "Paiement de l'abonnement premium"));
                                // Get.toNamed(Routes.CINETPAY);
                              } else {
                                PaymentService.instance.handlePayment();
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

  Widget _buildAddNewCardButton() {
    return GestureDetector(
      onTap: () {
        // Implémenter la logique d'ajout de nouvelle carte
        Get.back();
        Get.snackbar(
          'Info',
          'Fonctionnalité d\'ajout de carte à implémenter',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.add_circle_outline, color: Colors.blue),
            SizedBox(width: 16),
            Text(
              'Ajouter une nouvelle carte',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
