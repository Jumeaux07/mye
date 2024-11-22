import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:nom_du_projet/app/data/constant.dart';

class GetDataProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    httpClient.addAuthenticator((Request request) {
      final token = box.read("token");
      request.headers["Authorization"] = "Bearer $token";
      return request;
    });
  }

  Future<Response> getSecteur() async {
    final response = await get(baseUrl + getSecteurUrl);
    log("List of secteurs ${response.body}");
    return response;
  }

  Future<Response> findPositionAddress(String query) async {
    final response = await get(
        "https://api.locationiq.com/v1/autocomplete?key=$mapsToken&q=$query&limit=5&dedupe=1&");
    log("List of addresse ${response.body}");
    return response;
  }

  Future<Response> getAbonnement() async {
    final url = baseUrl + getAbonnementUrl;

    Response response;
    try {
      // Effectuer la requête GET
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});

      // Vérification de la réponse
      if (response.isOk) {
        log("List of abonnements: ${response.body}");
      } else {
        log("Erreur lors de la récupération des abonnements: ${response}");
      }
    } catch (e) {
      log("Exception lors de la récupération des abonnements: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la récupération des abonnements');
    }

    return response;
  }

  Future<Response> getAllUser() async {
    final url = baseUrl + getAllUserUrl;

    Response response;
    try {
      // Effectuer la requête GET
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});

      // Vérification de la réponse
      if (response.isOk) {
        log("List of abonnement all profiles: ${response.body}");
      } else {
        log("Erreur lors de la récupération des profiles: ${response}");
      }
    } catch (e) {
      log("Exception lors de la récupération des profiles: $e");
      return Response(
          statusCode: 500, body: 'Erreur lors de la récupération des profiles');
    }

    return response;
  }
}
