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
            title: const Text('Abonnement'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Titre
                Center(
                  child: Text(
                    '${controller.abonnement.value.libelle}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Durée
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Durée : ', style: TextStyle(fontSize: 16)),
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

                const SizedBox(height: 16),

                // Prix total
                Center(
                  child: Text(
                    'TOTAL ${controller.getTotal()} EUR',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Avantages inclus
                if (controller.abonnement.value.items != null &&
                    controller.abonnement.value.items!.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  const Text(
                    'Avantages inclus :',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: controller.abonnement.value
                        .getItemList()
                        .map((item) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 30),

                // Méthodes de paiement
                Obx(() => Column(
                      children: controller.savedPaymentMethods
                          .map((method) =>
                              _buildPaymentMethodTile(method, controller))
                          .toList(),
                    )),

                const SizedBox(height: 20),

                // Bouton de paiement
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.selectedMethod.value == null
                              ? null
                              : () {
                                  if (controller.selectedMethod.value?.id ==
                                      '1') {
                                    var url = Uri.parse(
                                        "${baseUrl}/get-factures?jours=${controller.selectedMonths.value}");
                                    http.get(
                                      url,
                                      headers: {
                                        'Content-Type': 'application/json',
                                        'Authorization':
                                            "Bearer ${box.read("token")}"
                                      },
                                    ).then((response) {
                                      if (response.statusCode == 201) {
                                        final data = jsonDecode(response.body);
                                        Get.to(() => CinetpayView(
                                            "Paiement de l'abonnement premium",
                                            genererChaineUnique(),
                                            (controller.abonnement.value
                                                        .price! *
                                                    controller
                                                        .selectedMonths.value)
                                                .toDouble(),
                                            data['data']['id'].toString()));
                                      } else {
                                        print('Erreur: ${response.body}');
                                      }
                                    }).catchError((error) {
                                      print('Erreur de connexion: $error');
                                    });
                                  } else {
                                    PaymentService.instance.handlePayment(
                                        controller.selectedMonths.value
                                            .toString(),
                                        (controller.abonnement.value.price! *
                                            controller.selectedMonths.value),
                                        controller.selectedMethod.value?.name ??
                                            "Carte de crédit");
                                  }
                                },
                          child: const Text(
                            'Confirmer',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  // Méthode de paiement avec design amélioré
  Widget _buildPaymentMethodTile(
      PaymentMethod method, AbonnementController controller) {
    final isSelected = controller.selectedMethod.value?.id == method.id;

    return GestureDetector(
      onTap: () => controller.selectMethod(method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.shade50
              : (Get.isDarkMode ? Colors.black26 : Colors.white),
          border: Border.all(
            color: isSelected
                ? Colors.blue
                : (Get.isDarkMode ? Colors.black38 : Colors.grey.shade300),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            method.imageAsset != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      method.imageAsset!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.contain,
                    ),
                  )
                : Text(
                    method.icon ?? '',
                    style: const TextStyle(fontSize: 40),
                  ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  if (method.lastDigits.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '•••• ${method.lastDigits}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue, size: 28),
          ],
        ),
      ),
    );
  }
}
