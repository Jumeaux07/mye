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

  /**
   * Récuperation de la liste des secteurs
   */
  Future<Response> getSecteur() async {
    final response = await get(baseUrl + getSecteurUrl);
    log("List of secteurs ${response.body}");
    return response;
  }

  /**
   * Récuperation de la liste des adresses maps
   */
  Future<Response> findPositionAddress(String query) async {
    final response = await get(
        "https://api.locationiq.com/v1/autocomplete?key=$mapsToken&q=$query&limit=5&dedupe=1&");
    log("List of addresse ${response.body}");
    return response;
  }

  /**
   * Récuperation de la liste des forfaits
   */
  Future<Response> getAbonnement() async {
    final url = baseUrl + getAbonnementUrl;

    Response response;
    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});

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

  /**
   * Récuperation de la liste des profils
   */
  Future<Response> getAllUser() async {
    final url = baseUrl + getAllUserUrl;

    Response response;
    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});

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

  /**
   * Récuperation du détails d'un utilisateur
   */
  Future<Response> showUser(String id) async {
    final url = baseUrl + showUserUrl + id;

    Response response;
    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});

      if (response.isOk) {
        log("show  profile: ${response.body}");
      } else {
        log("Erreur lors de la récupération du profile: ${response.body}");
      }
    } catch (e) {
      log("Exception lors de la récupération du profile: $e");
      return Response(
          statusCode: 500, body: 'Erreur lors de la récupération du profile');
    }

    return response;
  }

  /**
   * Récuperation des des informations de l'utilisateur connecté
   */

  Future<Response> getMe() async {
    final url = baseUrl + getUserUrl;
    Response response;

    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.isOk) {
        log("Informations de l'utilisateur connecté: ${response.body}");
      } else {
        log("Erreur lors de la récupération des informations de l'utilisateur connecté : ${response.body}");
      }
    } catch (e) {
      log("Exception lors de la récupération des informations de l'utilisateur connecté : $e");
      return Response(
          statusCode: 500,
          body:
              'Erreur lors de la récupération des informations de l\'utilisateur connecté');
    }
    return response;
  }

  Future<Response> updateUser(
      String? nom,
      String? prenom,
      String? secteur_activite,
      String? adresse_geographique,
      String? biographie,
      String? imageProfil) async {
    final url = baseUrl + updateUserUrl;
    var body = {
      "nom": nom,
      "prenom": prenom,
      "secteur_activite": secteur_activite,
      "adresse_geographique": adresse_geographique,
      "biographie": biographie,
      "profileImage": imageProfil
    };
    Response response;

    try {
      response = await post(
              url,
              headers: {"Authorization": "Bearer ${box.read("token")}"},
              body)
          .timeout(Duration(seconds: 10));
      if (response.isOk) {
        log("Mise a jour de l'utilisateur connecté: ${response.body}");
      } else {
        log("Erreur lors de la Mise a jour des informations de l'utilisateur connecté : ${response.body}");
      }
    } catch (e) {
      log("Exception lors de la Mise a jour des informations de l'utilisateur connecté : $e");
      return Response(
          statusCode: 500,
          body:
              'Erreur lors de la Mise a jour des informations de l\'utilisateur connecté');
    }
    return response;
  }

  Future<Response> updatePassword(String last_password, String password) async {
    final url = baseUrl + updatePswdUrl;
    var body = {"last_password": last_password, "password": password};
    Response response;

    try {
      response = await post(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"}, body);
      if (response.isOk) {
        log("Mise a jour du mot de passe de l'utilisateur: ${response.body}");
      } else {
        log("Erreur lors de la mise a jour du mot de passe de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      log("Exception lors de la mise a jour du mot de passe de l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jour du mot de passe de l'
              'utilisateur');
    }
    return response;
  }
}
