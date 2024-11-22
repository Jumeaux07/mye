import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';

// Définir un enum pour les états de paiement
enum PaymentStatus { success, failed, canceled, pending }

class PaymentService {
  PaymentService._();
  static final PaymentService instance = PaymentService._();

  Future<PaymentStatus> makePayment(
      {required int amount,
      required String currency,
      String merchantName = "MYE"}) async {
    try {
      // Créer le paiement
      String? paymentClientSecret = await _createPayment(amount, currency);
      if (paymentClientSecret == null) {
        return PaymentStatus.failed;
      }

      // Initialiser la feuille de paiement
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentClientSecret,
        merchantDisplayName: merchantName,
        // Vous pouvez ajouter d'autres paramètres ici
        appearance: PaymentSheetAppearance(),
      ));

      // Traiter le paiement
      return await _processPayment();
    } catch (e) {
      print('Erreur dans makePayment: $e');
      return PaymentStatus.failed;
    }
  }

  Future<String?> _createPayment(int amount, String currency) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: {
          "amount": _calculateAmount(amount),
          "currency": currency,
          "automatic_payment_methods[enabled]":
              false, // Activer les méthodes de paiement automatiques
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $STRIPEKEY",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['client_secret'];
      } else {
        print('Erreur Stripe: ${response.data}');
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        print('Erreur Stripe API: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      } else {
        print('Erreur inattendue: $e');
      }
      return null;
    }
  }

  Future<PaymentStatus> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return PaymentStatus.success;
    } catch (e) {
      if (e is StripeException) {
        if (e.error.code == FailureCode.Canceled) {
          print('Paiement annulé par l\'utilisateur');
          return PaymentStatus.canceled;
        }
        print('Erreur Stripe: ${e.error.localizedMessage}');
      } else {
        print('Erreur inattendue: $e');
      }
      return PaymentStatus.failed;
    }
  }

  int _calculateAmount(int amount) {
    return amount * 100;
  }

  // Dans votre widget/page
  Future<void> handlePayment() async {
    try {
      final status = await PaymentService.instance.makePayment(
        amount: 10, // montant en dollars/euros
        currency: 'eur', // ou 'usd'
      );

      switch (status) {
        case PaymentStatus.success:
          // Afficher un message de succès
          ScaffoldMessenger.of(Get.context!)
              .showSnackBar(SnackBar(content: Text('Paiement réussi !')));
          // Mettre à jour votre UI ou naviguer vers une autre page
          break;

        case PaymentStatus.canceled:
          // L'utilisateur a annulé, vous pouvez soit ne rien faire,
          // soit afficher un message discret
          break;

        case PaymentStatus.failed:
          ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
            content: Text('Échec du paiement. Veuillez réessayer.'),
            backgroundColor: Colors.red,
          ));
          break;

        case PaymentStatus.pending:
          // Gérer l'état en attente si nécessaire
          break;
      }
    } catch (e) {
      print('Erreur lors du traitement du paiement: $e');
    }
  }
}
