import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nom_du_projet/app/data/constant.dart';

class PayementService {
  PayementService._();

  static final PayementService instance = PayementService._();

  Future<void> makePayement() async {
    try {
      String? payementClientSecret = await _createPayement(10, "usd");
      if (payementClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: payementClientSecret,
              merchantDisplayName: "MYE APP"));
      await _processPayement();
    } catch (e) {}
  }

  Future<String?> _createPayement(int amount, String currency) async {
    try {
      final dio = Dio();

      // Correction 1 : Utiliser la bonne URL de l'API Stripe
      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: {"amount": _calculateAmount(amount), "currency": currency},
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            // Correction 2 : Utiliser la clé secrète Stripe
            "Authorization": "Bearer ${STRIPEKEY}",
            "Content-Type": "application/x-www-form-urlencoded"
          }));

      // Correction 3 : Retourner le client secret du PaymentIntent
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        // Extraire le client secret
        return response.data['client_secret'];
      }
    } catch (e) {
      // Correction 4 : Gestion plus détaillée des erreurs
      if (e is DioException) {
        print('Erreur Stripe: ${e.response?.data}');
        print('Status code: ${e.response?.statusCode}');
      } else {
        print('Erreur inattendue: $e');
      }
    }
    return null;
  }

  Future<void> _processPayement() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print(e);
    }
  }

// Méthode pour calculer le montant (Stripe utilise des centimes)
  int _calculateAmount(int amount) {
    return amount * 100; // Convertir en centimes
  }
}
