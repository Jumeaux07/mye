import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:nom_du_projet/app/data/constant.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  final storage = GetStorage();
  final dio = Dio();

  @override
  RouteSettings? redirect(String? route) {
    final token = storage.read('token');

    if (token == null) {
      return const RouteSettings(name: '/login');
    }

    dio
        .get(
      baseUrl + getUserUrl, // Remplacer par votre URL
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    )
        .then((response) {
      if (response.statusCode == 200) {
        // Token valide, stocker les informations de l'utilisateur si nécessaire

        return null; // Autoriser l'accès à la route
      } else {
        // Token invalide
        _handleInvalidToken();
        return const RouteSettings(name: '/login');
      }
    }).catchError((e) {
      if (e is DioError && e.response?.statusCode == 401 ||
          e.response?.statusCode == 405) {
        // Token non autorisé
        _handleInvalidToken();
      }
      return const RouteSettings(name: '/login');
    });

    return null;
  }

  Future<void> _handleInvalidToken() async {
    // Nettoyer le stockage
    await storage.remove('token');
  }
}
