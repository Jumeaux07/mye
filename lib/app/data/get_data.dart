import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';

class GetDataProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;
    _initializeHttpClient();
    _initConnectivityListener();
  }

  void _initializeHttpClient() {
    httpClient.baseUrl = baseUrl;
    httpClient.addAuthenticator((Request request) async {
      final token = box.read("token");
      request.headers["Authorization"] = "Bearer $token";
      return request;
    });

    // Ajouter un timeout par défaut
    httpClient.timeout = const Duration(seconds: 30);
  }

  void _initConnectivityListener() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
    }
  }

  Future<Response<T>> safeApiCall<T>(
      Future<Response<T>> Function() apiCall) async {
    try {
      // Vérifier la connexion Internet avant l'appel
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return Response(
          statusCode: 503,
          statusText: 'Pas de connexion Internet',
          body: null,
        );
      }

      final response = await apiCall();

      // Vérifier si la réponse est null
      if (response.body == null) {
        return Response(
          statusCode: 204, // No Content
          statusText: 'Aucune donnée disponible',
          body: null,
        );
      }

      return response;
    } on TimeoutException {
      return Response(
        statusCode: 408,
        statusText: 'Délai d\'attente dépassé',
        body: null,
      );
    } on SocketException {
      Get.snackbar(
        'Connexion perdue',
        'Vérifiez votre connexion Internet',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return Response(
        statusCode: 503,
        statusText: 'Erreur de connexion au serveur',
        body: null,
      );
    } catch (e) {
      return Response(
        statusCode: 500,
        statusText: 'Erreur inattendue: ${e.toString()}',
        body: null,
      );
    }
  }

  /**
   * Récuperation de la liste des secteurs
   */
  Future<Response> getSecteur() async {
    return safeApiCall(() async {
      final response = await get(baseUrl + getSecteurUrl);

      if (response.statusCode == 405 || response.statusCode == 401) {
        Get.offAllNamed(Routes.LOGIN);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Vous n'êtes pas connecté")));
      } else if (response.statusCode == 503) {
        return Response(
          statusCode: 503,
          statusText: 'Pas de connexion Internet',
          body: null,
        );
      } else if (response.body == null) {
        Response(
          statusCode: 204, // No Content
          statusText: 'Aucune donnée disponible',
          body: null,
        );
      } else if (response.status.isOk) {
        print("Liste des secteurs récupérée: ${response.body}");
      }
      return response;
    });
  }

  /**
   * Recuperation des pubs
   */

  Future<Response> getPub() async {
    return safeApiCall(() async {
      final response = await get(baseUrl + getPubUrl,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.statusCode == 503) {
        return Response(
          statusCode: 503,
          statusText: 'Pas de connexion Internet',
          body: null,
        );
      } else if (response.body == null) {
        Response(
          statusCode: 204, // No Content
          statusText: 'Aucune donnée disponible',
          body: null,
        );
      } else if (response.status.isOk) {
        print("Liste des secteurs récupérée: ${response.body}");
      }
      return response;
    });
  }

  Future<Response> search(String? search) async {
    return safeApiCall(() async {
      final response = await post(
        baseUrl + searchUrl,
        {
          "search": search,
        },
        headers: {"Authorization": "Bearer ${box.read("token")}"},
      );
      if (response.statusCode == 503) {
        return Response(
          statusCode: 503,
          statusText: 'Pas de connexion Internet',
          body: null,
        );
      } else if (response.body == null) {
        Response(
          statusCode: 204, // No Content
          statusText: 'Aucune donnée disponible',
          body: null,
        );
      } else if (response.status.isOk) {
        print("Liste des recherche récupérée: ${response.body}");
      }
      return response;
    });
  }

  /**
   * Récuperation de la liste des adresses maps
   */
  Future<Response> findPositionAddress(String query) async {
    final response = await get(
        "https://api.locationiq.com/v1/autocomplete?key=${Env.mapsToken}&countrycodes=CI&q=$query&limit=5&dedupe=1&");
    print("List of addresse ${response.body}");
    return response;
  }

  /**
   * Récuperation de la liste des forfaits
   */
  Future<Response> getAbonnement() async {
    return safeApiCall(() async {
      final url = baseUrl + getAbonnementUrl;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("List of abonnements: ${response.body}");
        } else {
          print("Erreur lors de la récupération des abonnements: ${response}");
        }
        return response;
      } catch (e) {
        print("Exception lors de la récupération des abonnements: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la récupération des abonnements');
      }
    });
  }

  /**
   * Récuperation de la liste des profils
   */
  Future<Response> getAllUser() async {
    return safeApiCall(() async {
      final url = baseUrl + getAllUserUrl;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${await box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("List of abonnement all profiles: ${response.body}");
        } else {
          print(
              "Erreur lors de la récupération des profiles: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lors de la récupération des profiles: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la récupération des profiles');
      }
    });
  }

  /**
   * Récuperation du détails d'un utilisateur
   */
  Future<Response> showUser(String id) async {
    return safeApiCall(() async {
      final url = baseUrl + showUserUrl + id;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("show  profile: ${response.body}");
        } else {
          print("Erreur lors de la récupération du profile: ${response.body}");
        }
        return response;
      } catch (e) {
        print("Exception lors de la récupération du profile: $e");
        return Response(
            statusCode: 500, body: 'Erreur lors de la récupération du profile');
      }
    });
  }

  /**
   * Récuperation des des informations de l'utilisateur connecté
   */

  Future<Response> getMe() async {
    return safeApiCall(() async {
      final url = baseUrl + getUserUrl;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Informations de l'utilisateur connecté: ${response.body}");
        } else {
          print(
              "Erreur lors de la récupération des informations de l'utilisateur connecté : ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la récupération des informations de l'utilisateur connecté : $e");
        return Response(
            statusCode: 500,
            body:
                'Erreur lors de la récupération des informations de l\'utilisateur connecté');
      }
    });
  }

/**
 * Modification du mot de passe de l'utilisateur
 */
  Future<Response> updatePassword(String last_password, String password) async {
    return safeApiCall(() async {
      final url = baseUrl + updatePswdUrl;
      var body = {"last_password": last_password, "password": password};

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print(
              "Mise a jour du mot de passe de l'utilisateur: ${response.body}");
        } else {
          print(
              "Erreur lors de la mise a jour du mot de passe de l'utilisateur: ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la mise a jour du mot de passe de l'utilisateur: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la mise a jour du mot de passe de l'
                'utilisateur');
      }
    });
  }

/**
 * Envoie de message
 */
  Future<Response> sendMessage(
      String recever_id, String contenu, String? conversation_id) async {
    return safeApiCall(() async {
      final url = baseUrl + sendMessageUrlUrl;
      var body = conversation_id == null
          ? {"reciver_id": recever_id, "contenu": contenu}
          : {
              "reciver_id": recever_id,
              "contenu": contenu,
              "conversation_id": conversation_id
            };

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Envoie de message: ${response.body}");
        } else {
          print("Erreur lors de l'envoie de message: ${response.body}");
        }
        return response;
      } catch (e) {
        print("Exception lors de l'envoie de message $e");
        return Response(
            statusCode: 500, body: "Erreur lors de l'envoie de message");
      }
    });
  }

/**
 * Mise a jour des compétences de l'utilisateur
 */
  Future<Response> updateSkill(String skill) async {
    return safeApiCall(() async {
      final url = baseUrl + updateSkilUrl;
      var body = {"skill": skill};

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print(
              "Mise a jour des compétences de l'utilisateur: ${response.body}");
        } else {
          print(
              "Erreur lors de la mise a jour des compétences de l'utilisateur: ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la mise a jour des compétences de l'utilisateur: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la mise a jour des compétences  de l'
                'utilisateur');
      }
    });
  }

  /**
 * Mise a jour des centre d'interet de l'utilisateur
 */
  Future<Response> updateCentreInteret(String centreInteret) async {
    return safeApiCall(() async {
      final url = baseUrl + updatecentreInteretUrl;
      var body = {"centre_interet": centreInteret};

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print(
              "Mise a jour des centre d'interet de l'utilisateur: ${response.body}");
        } else {
          print(
              "Erreur lors de la mise a jour des centre d'interet de l'utilisateur: ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la mise a jour des centre d'interet de l'utilisateur: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la mise a jour des centre d'
                'interet  de l'
                'utilisateur');
      }
    });
  }

  Future<Response> saveSecteur(String libelle) async {
    return safeApiCall(() async {
      final url = baseUrl + saveSecteurUrl;
      var body = {"libelle": libelle};

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Save secteur: ${response.body}");
        } else {
          print("save secteur: ${response.body}");
        }
        return response;
      } catch (e) {
        print("Save secteur: $e");
        return Response(
            statusCode: 500, body: 'Erreur lors de la sauvegarde du secteur');
      }
    });
  }

/**
 * Mise a jour du profile de l'utilisateur
 */
  Future<Response> updateProfile(String nom, String prenom, String secteur,
      String ville, String lat, String long) async {
    return safeApiCall(() async {
      final url = baseUrl + updateProfillUrl;
      print(url);
      var body = {
        "nom": nom,
        "prenom": prenom,
        "secteur_activite": secteur,
        "adresse_geographique": ville,
        "latitude": lat,
        "longitude": long,
      };

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Mise a jour  du profile de l'utilisateur: ${response.body}");
        } else {
          print(
              "Erreur lors de la mise a jour ddu profile  de l'utilisateur: ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la mise a jour du profile  de l'utilisateur: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la mise a jourdu profile   de l'
                'utilisateur');
      }
    });
  }

/**
 * Mise a jour de l'image de profile de l'utilisateur
 */
  Future<Response> updateImageProfile(String imageBase64) async {
    final url = baseUrl + updateImageUrl;
    var body = {"profileImage": imageBase64};

    try {
      final response = await post(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"}, body);
      if (response.statusCode == 405 || response.statusCode == 401) {
        Get.offAllNamed(Routes.LOGIN);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Vous n'êtes pas connecté")));
      } else if (response.statusCode == 503) {
        return Response(
          statusCode: 503,
          statusText: 'Pas de connexion Internet',
          body: null,
        );
      } else if (response.body == null) {
        Response(
          statusCode: 204, // No Content
          statusText: 'Aucune donnée disponible',
          body: null,
        );
      } else if (response.isOk) {
        print("Mise a jour de image de l'utilisateur: ${response.body}");
      } else {
        print(
            "Erreur lors de la mise a jour de image de l'utilisateur: ${response.body}");
      }
      return response;
    } catch (e) {
      print("Exception lors de la mise a jour imagede l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body:
              'Erreur lors de la mise a jour de image hie  de l\'utilisateur');
    }
  }

/**
 * Mise a jour de l'experience de l'utilisateur
 */
  Future<Response> updateExperience(
      String poste, String entreprise, String dateDebut, String dateFin) async {
    return safeApiCall(() async {
      final url = baseUrl + updateExperienceUrl;
      var body = {
        "poste": poste,
        "nom_entreprise": entreprise,
        "date_debut": dateDebut,
        "date_fin": dateFin
      };

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print(
              "Mise a jour de la experience de l'utilisateur: ${response.body}");
        } else {
          print(
              "Erreur lors de la mise a jour de la experience de l'utilisateur: ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la mise a jour de la experience de l'utilisateur: $e");
        return Response(
            statusCode: 500,
            body:
                'Erreur lors de la mise a jour de la experience  de l\'utilisateur');
      }
    });
  }

/**
 * Recuperation des conversations
 */
  Future<Response> getConversation() async {
    final url = baseUrl + getConversationUrl;

    try {
      final response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.statusCode == 405 || response.statusCode == 401) {
        Get.offAllNamed(Routes.LOGIN);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Vous n'êtes pas connecté")));
      } else if (response.statusCode == 503) {
        return Response(
          statusCode: 503,
          statusText: 'Pas de connexion Internet',
          body: null,
        );
      } else if (response.body == null) {
        return Response(
          statusCode: 204, // No Content
          statusText: 'Aucune donnée disponible',
          body: null,
        );
      } else if (response.isOk) {
        print("Liste des conversation: ${response.body}");
      } else {
        print(
            "Erreur lors de la recuperation des conversations: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exception lorsa de la recuperation des conversations: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de recuperation des convesations');
    }
  }

/**
 * Recuperation des messages d'une conversation
 */
  Future<Response> getMessage(String conversation_id) async {
    return safeApiCall(() async {
      final url = baseUrl + getmessageUrl + conversation_id;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Liste des conversation: ${response.body}");
        } else {
          print(
              "Erreur lors de la recuperation des conversations: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lorsa de la recuperation des conversations: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de recuperation des convesations');
      }
    });
  }

/**
 * Mise a jour de la biographie de l'utilisateur
 */
  Future<Response> updateBio(String bio) async {
    return safeApiCall(() async {
      final url = baseUrl + updateBioUrl;
      var body = {"biographie": bio};

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print(
              "Mise a jour de la biographie de l'utilisateur: ${response.body}");
        } else {
          print(
              "Erreur lors de la mise a jour de la biographie de l'utilisateur: ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la mise a jour de la biographie de l'utilisateur: $e");
        return Response(
            statusCode: 500,
            body:
                'Erreur lors de la mise a jour de la biographie  de l\'utilisateur');
      }
    });
  }

/**
 * Recuperation de toutes notifications de l'utilisateur
 */
  Future<Response> getAllNotification() async {
    return safeApiCall(() async {
      final url = baseUrl + getAllNotificationUrl;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print(
              "Récuperation des notifications de l'utilisateur: ${response.body}");
        } else {
          print(
              "Erreur lors de la récuperation des notifications de l'utilisateur: ${response.body}");
        }
        return response;
      } catch (e) {
        print(
            "Exception lors de la récuperation des notifications de l'utilisateur: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la récuperation des notifications  de l'
                'utilisateur');
      }
    });
  }

/**
 * Lecture d'une notification
 */
  Future<Response> readNotification(String id) async {
    return safeApiCall(() async {
      final url = baseUrl + readNotificationUrl + id;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Lecture de notification ${response.body}");
        } else {
          print(
              "Erreur lors de la lecture d'une notification: ${response.body}");
        }
        return response;
      } catch (e) {
        print("Exception lors de la lecture d'une notification: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la lecture d\'une notification');
      }
    });
  }

/**
 * Lecture de toutes les notifications
 */
  Future<Response> readAllNotification() async {
    return safeApiCall(() async {
      final url = baseUrl + readAllNotificationUrl;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Lecture de toutes notification ${response.body}");
        } else {
          print(
              "Erreur lors de la lecture de toutes notification: ${response.body}");
        }
        return response;
      } catch (e) {
        print("Exception lors de la lecture de toutes notification: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la lecture de toutes notification');
      }
    });
  }

/**
 * Suppression d'une notification
 */
  Future<Response> deleteNotification(String id) async {
    final url = baseUrl + deleteNotificationUrl + id;

    try {
      final response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.statusCode == 405 || response.statusCode == 401) {
        Get.offAllNamed(Routes.LOGIN);
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text("Vous n'êtes pas connecté")));
      } else if (response.statusCode == 503) {
        return Response(
          statusCode: 503,
          statusText: 'Pas de connexion Internet',
          body: null,
        );
      } else if (response.body == null) {
        Response(
          statusCode: 204, // No Content
          statusText: 'Aucune donnée disponible',
          body: null,
        );
      } else if (response.isOk) {
        print("suppression de notification ${response.body}");
      } else {
        print(
            "Erreur lors de la suppression d'une notification: ${response.body}");
      }
      return response;
    } catch (e) {
      print("Exception lors de la suppression d'une notification: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la suppression d\'une notification');
    }
  }

/**
 * Suppression de toutes les notifications
 */
  Future<Response> deleteAllNotification() async {
    return safeApiCall(() async {
      final url = baseUrl + deleteAllNotificationUrl;

      try {
        final response = await get(url,
            headers: {"Authorization": "Bearer ${box.read("token")}"});
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("suppression de toutes notification ${response.body}");
        } else {
          print(
              "Erreur lors de la suppression de toutes notification: ${response.body}");
        }
        return response;
      } catch (e) {
        print("Exception lors de la suppression de toutes notification: $e");
        return Response(
            statusCode: 500,
            body: 'Erreur lors de la suppression de toutes notification');
      }
    });
  }

  /**
 * Envoi de fichier
 */
  Future<Response> sendFile(String recever_id, File file,
      {String? conversation_id}) async {
    return safeApiCall(() async {
      final form = FormData({
        'fichier': MultipartFile(file,
            filename: '${file.path.split('/').last.replaceAll(' ', '')}'),
        'reciver_id': recever_id,
        'conversation_id': conversation_id
      });
      final url = baseUrl + sendFileUrl;

      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            form);
        log("${response.statusCode}");
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Envoie de fichier: ${response.body}");
        } else {
          print("Erreur lors de l'envoie de fichier: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lors de l'envoie de fichier $e");
        return Response(
            statusCode: 500, body: "Erreur lors de l'envoie de fichier");
      }
    });
  }

  /*
 * Envoi de demande de conection
 */
  Future<Response> sendRequest(String recever_id) async {
    return safeApiCall(() async {
      final body = {
        'receiver_id': recever_id,
      };
      final url = baseUrl + sendRequestUrl;
      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        print("${url} ${response.body}");
        log("${response.statusCode}");
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Envoie de demande de connection: ${response.body}");
        } else {
          print("Erreur lors de l'envoie  de demande: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lors de l'envoie  de demande $e");
        return Response(
            statusCode: 500, body: "Erreur lors de l'envoie  de demande");
      }
    });
  }

  Future<Response> sendResponseRequest(
      String responseUser, String id_user) async {
    return safeApiCall(() async {
      final body = {
        'status': responseUser,
      };
      final url = baseUrl + sendResponseRequestUrl + id_user;
      print(url);
      try {
        final response = await post(
            url,
            headers: {"Authorization": "Bearer ${box.read("token")}"},
            body);
        log("${response.statusCode}");
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("Envoie de fichier: ${response.body}");
        } else {
          print("Erreur lors de l'envoie  de reponse: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lors de l'envoie  de reponse $e");
        return Response(
            statusCode: 500, body: "Erreur lors de l'envoie  de reponse");
      }
    });
  }

  /**
 * Liste des demandes de connexion
 */
  Future<Response> getRequest() async {
    return safeApiCall(() async {
      final url = baseUrl + getRequestUrl;

      try {
        final response = await get(
          url,
          headers: {"Authorization": "Bearer ${box.read("token")}"},
        );
        log("${response.body}");
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("recuperation  de demande: ${response.body}");
        } else {
          print(
              "Erreur lors de recuperation  de demande: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lors de recuperation  de demande $e");
        return Response(
            statusCode: 500, body: "Erreur lors de recuperation  de demande");
      }
    });
  }

  Future<Response> getRequestSend() async {
    return safeApiCall(() async {
      final url = baseUrl + getRequesSendtUrl;

      try {
        final response = await get(
          url,
          headers: {"Authorization": "Bearer ${box.read("token")}"},
        );
        log("${response.body}");
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("recuperation  de demande: ${response.body}");
        } else {
          print(
              "Erreur lors de recuperation  de demande envoye: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lors de recuperation  de demande envoye $e");
        return Response(
            statusCode: 500,
            body: "Erreur lors de recuperation  de demande envoye");
      }
    });
  }

  Future<Response> getRelation() async {
    return safeApiCall(() async {
      final url = baseUrl + getRelationUrl;

      try {
        final response = await get(
          url,
          headers: {"Authorization": "Bearer ${box.read("token")}"},
        );
        log("${response.body}");
        if (response.statusCode == 405 || response.statusCode == 401) {
          Get.offAllNamed(Routes.LOGIN);
          ScaffoldMessenger.of(Get.context!).showSnackBar(
              SnackBar(content: Text("Vous n'êtes pas connecté")));
        } else if (response.statusCode == 503) {
          return Response(
            statusCode: 503,
            statusText: 'Pas de connexion Internet',
            body: null,
          );
        } else if (response.body == null) {
          return Response(
            statusCode: 204, // No Content
            statusText: 'Aucune donnée disponible',
            body: null,
          );
        } else if (response.isOk) {
          print("recuperation  de demande: ${response.body}");
        } else {
          print(
              "Erreur lors de re relationcuperation  des relations: ${response.statusCode}");
        }
        return response;
      } catch (e) {
        print("Exception lors de recuperation  des relations $e");
        return Response(
            statusCode: 500, body: "Erreur lors de recuperation  des");
      }
    });
  }
}
