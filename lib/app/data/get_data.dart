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
    print("List of secteurs ${response.body}");
    return response;
  }

  /**
   * Récuperation de la liste des adresses maps
   */
  Future<Response> findPositionAddress(String query) async {
    final response = await get(
        "https://api.locationiq.com/v1/autocomplete?key=$mapsToken&q=$query&limit=5&dedupe=1&");
    print("List of addresse ${response.body}");
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
        print("List of abonnements: ${response.body}");
      } else {
        print("Erreur lors de la récupération des abonnements: ${response}");
      }
    } catch (e) {
      print("Exception lors de la récupération des abonnements: $e");
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
        print("List of abonnement all profiles: ${response.body}");
      } else {
        print("Erreur lors de la récupération des profiles: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la récupération des profiles: $e");
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
        print("show  profile: ${response.body}");
      } else {
        print("Erreur lors de la récupération du profile: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la récupération du profile: $e");
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
        print("Informations de l'utilisateur connecté: ${response.body}");
      } else {
        print("Erreur lors de la récupération des informations de l'utilisateur connecté : ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la récupération des informations de l'utilisateur connecté : $e");
      return Response(
          statusCode: 500,
          body:
              'Erreur lors de la récupération des informations de l\'utilisateur connecté');
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
        print("Mise a jour du mot de passe de l'utilisateur: ${response.body}");
      } else {
        print("Erreur lors de la mise a jour du mot de passe de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la mise a jour du mot de passe de l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jour du mot de passe de l'
              'utilisateur');
    }
    return response;
  }

  Future<Response> updateSkill(String skill) async {
    final url = baseUrl + updateSkilUrl;
    var body = {"skill": skill};
    Response response;

    try {
      response = await post(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"}, body);
      if (response.isOk) {
        print("Mise a jour des compétences de l'utilisateur: ${response.body}");
      } else {
        print("Erreur lors de la mise a jour des compétences de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la mise a jour des compétences de l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jour des compétences  de l'
              'utilisateur');
    }
    return response;
  }

    Future<Response> updateProfile(String nom,String prenom, String secteur,String ville) async {
    final url = baseUrl + updateProfillUrl;
    print(url);
    var body = {
      "nom": nom,
      "prenom": prenom,
      "secteur_activite": secteur,
       "adresse_geographique": ville,
      };
    Response response;

    try {
      response = await post(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"}, body);
      if (response.isOk) {
        print("Mise a jour  du profile de l'utilisateur: ${response.body}");
      } else {
        print("Erreur lors de la mise a jour ddu profile  de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la mise a jour du profile  de l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jourdu profile   de l'
              'utilisateur');
    }
    return response;
  }


    Future<Response> updateImageProfile(String imageBase64) async {
    final url = baseUrl + updateImageUrl;
    var body = {"profileImage": imageBase64};
    Response response;

    try {
      response = await post(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"}, body);
      if (response.isOk) {
        print("Mise a jour de image de l'utilisateur: ${response.body}");
      } else {
        print("Erreur lors de la mise a jour de image de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la mise a jour imagede l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jour de image hie  de l\'utilisateur');
    }
    return response;
  }

    Future<Response> updateExperience(String poste, String entreprise, String dateDebut, String dateFin) async {
    final url = baseUrl + updateExperienceUrl;
    var body = {
      "poste": poste,
      "nom_entreprise": entreprise,
      "date_debut":dateDebut,
      "date_fin":dateFin
      };
    Response response;

    try {
      response = await post(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"}, body);
      if (response.isOk) {
        print("Mise a jour de la experience de l'utilisateur: ${response.body}");
      } else {
        print("Erreur lors de la mise a jour de la experience de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la mise a jour de la experience de l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jour de la experience  de l\'utilisateur');
    }
    return response;
  }

    Future<Response> getConversation() async {
    final url = baseUrl + updateBioUrl;
    Response response;

    try {
      response = await get(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.isOk) {
        print("Liste des conversation: ${response.body}");
      } else {
        print("Erreur lors de la recuperation des conversations: ${response.body}");
      }
    } catch (e) {
      print("Exception lorsa de la recuperation des conversations: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de recuperation des convesations');
    }
    return response;
  }

    Future<Response> updateBio(String bio) async {
    final url = baseUrl + updateBioUrl;
    var body = {"biographie": bio};
    Response response;

    try {
      response = await post(
          url, headers: {"Authorization": "Bearer ${box.read("token")}"}, body);
      if (response.isOk) {
        print("Mise a jour de la biographie de l'utilisateur: ${response.body}");
      } else {
        print("Erreur lors de la mise a jour de la biographie de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la mise a jour de la biographie de l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la mise a jour de la biographie  de l\'utilisateur');
    }
    return response;
  }

  Future<Response> getAllNotification() async {
    final url = baseUrl + getAllNotificationUrl;
    Response response;

    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.isOk) {
        print("Récuperation des notifications de l'utilisateur: ${response.body}");
      } else {
        print("Erreur lors de la récuperation des notifications de l'utilisateur: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la récuperation des notifications de l'utilisateur: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la récuperation des notifications  de l'
              'utilisateur');
    }
    return response;
  }

  Future<Response> readNotification(String id) async {
    final url = baseUrl + readNotificationUrl + id;
    Response response;

    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.isOk) {
        print("Lecture de notification ${response.body}");
      } else {
        print("Erreur lors de la lecture d'une notification: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la lecture d'une notification: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la lecture d\'une notification');
    }
    return response;
  }

  Future<Response> readAllNotification() async {
    final url = baseUrl + readAllNotificationUrl;
    Response response;

    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.isOk) {
        print("Lecture de toutes notification ${response.body}");
      } else {
        print("Erreur lors de la lecture de toutes notification: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la lecture de toutes notification: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la lecture de toutes notification');
    }
    return response;
  }

  Future<Response> deleteNotification(String id) async {
    final url = baseUrl + deleteNotificationUrl + id;
    Response response;

    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.isOk) {
        print("suppression de notification ${response.body}");
      } else {
        print("Erreur lors de la suppression d'une notification: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la suppression d'une notification: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la suppression d\'une notification');
    }
    return response;
  }

  Future<Response> deleteAllNotification() async {
    final url = baseUrl + deleteAllNotificationUrl;
    Response response;

    try {
      response = await get(url,
          headers: {"Authorization": "Bearer ${box.read("token")}"});
      if (response.isOk) {
        print("suppression de toutes notification ${response.body}");
      } else {
        print("Erreur lors de la suppression de toutes notification: ${response.body}");
      }
    } catch (e) {
      print("Exception lors de la suppression de toutes notification: $e");
      return Response(
          statusCode: 500,
          body: 'Erreur lors de la suppression de toutes notification');
    }
    return response;
  }
}
