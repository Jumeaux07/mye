import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/abonnement.dart';

import '../../../data/get_data.dart';
import '../../../widgets/custom_alert.dart';
import '../../../widgets/soucription_plan.dart';

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final String lastDigits;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    this.lastDigits = '',
  });
}

class AbonnementController extends GetxController {
  //TODO: Implement AbonnementController

  final Rx<SubscriptionPlan> plans = SubscriptionPlan(
    name: 'Gratuit',
    price: '0FCFA',
    color: Colors.grey.shade200,
    features: [
      'Fonctionnalités de base',
      'Messages limités',
      'Support par email',
    ],
  ).obs;

  final Rx<AbonnementModel> abonnement = AbonnementModel().obs;

  final GetDataProvider _dataProvider = GetDataProvider();

  var selectedMethod = Rxn<PaymentMethod>();
  var isLoading = false.obs;

  // Simuler des méthodes de paiement sauvegardées
  final savedPaymentMethods = [
    PaymentMethod(
      id: '1',
      name: 'Mobile Money',
      icon: '💲',
      lastDigits: '',
    ),
    PaymentMethod(
      id: '2',
      name: 'Carte de crédit',
      icon: '💳',
      lastDigits: '',
    ),
  ].obs;

  void selectMethod(PaymentMethod method) {
    selectedMethod.value = method;
    log(method.id);
  }

  Future<void> confirmPaymentMethod() async {
    if (selectedMethod.value == null) return;

    isLoading.value = true;
    try {
      // Simuler un appel API
      await Future.delayed(Duration(seconds: 1));
      Get.back(result: selectedMethod.value);
      Get.snackbar(
        'Succès',
        'Moyen de paiement sélectionné',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la sélection',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processPayment() async {
    try {
      // Créer les données complètes de la carte
      final paymentMethodData = PaymentMethodData(
        billingDetails: BillingDetails(
          name: 'John Doe',
          email: 'johndoe@example.com',
          phone: '+1234567890',
        ),
        // Ajoutez les détails complets de la carte
      );

      // Créer les paramètres du PaymentMethod avec les données de carte complètes
      final paymentMethodParams = PaymentMethodParams.card(
        paymentMethodData: paymentMethodData,
      );

      // Créer le PaymentMethod
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: paymentMethodParams,
      );

      // Convertir en PaymentMethodDataCardFromMethod
      final cardFromMethodData = PaymentMethodDataCardFromMethod(
        paymentMethodId: paymentMethod.id,
      );

      // Confirmer la Payment Intent avec le client secret
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: 'YOUR_CLIENT_SECRET',
        data: PaymentMethodParams.cardFromMethodId(
          paymentMethodData: cardFromMethodData,
        ),
      );

      log("Payment successful: ${paymentMethod.id}");
    } catch (e) {
      log("Error during payment: $e");
    }
  }

  Future<void> getAbonnement() async {
    try {
      // change(null, status: RxStatus.loading());
      final response = await _dataProvider.getAbonnement();

      if (response.statusCode == 200) {
        abonnement.value = AbonnementModel.fromJson(response.body['data']);

        // change(abonnement, status: RxStatus.success());
      } else {
        Get.dialog(CustomAlertDialog(
            message: "Erreur de chargement des données",
            onPressed: () {
              Get.back();
            },
            showAlertIcon: true));
        // change(null,
        //     status: RxStatus.error(
        //         "Une erreur s'produite lors du chargement des données"));
      }
    } catch (e) {
      Get.dialog(CustomAlertDialog(
          message: "Erreur de chargement des données : $e",
          onPressed: () {
            Get.back();
          },
          showAlertIcon: true));
      // change(null,
      //     status: RxStatus.error(
      //         "Une erreur s'produite lors du chargement des données => $e"));
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
