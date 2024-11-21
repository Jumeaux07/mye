import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/cinetpay/views/cinetpay_view.dart';
import 'package:nom_du_projet/app/services/payement_service.dart';

import '../controllers/abonnement_controller.dart';

class AbonnementView extends GetView<AbonnementController> {
  AbonnementView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getAbonnement();
    return Obx(() => Scaffold(
        appBar: AppBar(
          title: Text('Abonnements'),
          centerTitle: true,
        ),
        body: Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Stack(
            children: [
              if (controller.plans.value.isPopular)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Plus populaire',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.abonnement.value.libelle ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${controller.abonnement.value.price ?? 0} FCFA",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
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
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implémenter la logique d'abonnement
                          Get.to(() => CinetpayView());
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wallet),
                              SizedBox(width: 5),
                              Text(
                                'Payer par Mobile Money',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implémenter la logique d'abonnement
                          PayementService.instance.makePayement();
                          print("Payer par carte");
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.credit_card),
                              SizedBox(width: 5),
                              Text(
                                'Payer par carte bancaire',
                                // 'Choisir ${controller.plans.value.name}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
