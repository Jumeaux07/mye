import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:nom_du_projet/app/data/constant.dart';

class ProximityService {
  Future<void> detectNearbyUsers() async {
    log("Proxymite");
    // Vérification des permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Récupération de la position actuelle
    Position position = await Geolocator.getCurrentPosition();
    log("User position => ${position}");
    log("URL => ${baseUrl}/users/nearby?latitude=${position.latitude}&longitude=${position.longitude}&radius=2");
    // Appel API pour récupérer les utilisateurs
    final response = await http.get(
      Uri.parse(
          '${baseUrl}/users/nearby?latitude=${position.latitude}&longitude=${position.longitude}&radius=2'),
      headers: {
        "Authorization": "Bearer ${box.read("token")}",
      },
    );

    if (response.statusCode == 200) {
      // Traitement des utilisateurs à proximité
      log("Nouvelle utilisateurs dans la zone");

      // Logique d'affichage ou de notification
    } else {
      log("Erreur users matching ${response.body}");
    }
  }
}
