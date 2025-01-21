import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityMiddleware extends GetMiddleware {
  @override
  int? get priority => 2;

  final _connectivity = Connectivity();
  final _internetChecker = InternetConnectionChecker.createInstance();

  final String offlineRoute;
  final bool redirectToOffline;
  final Duration checkTimeout;

  ConnectivityMiddleware({
    this.offlineRoute = '/offline',
    this.redirectToOffline = true,
    this.checkTimeout = const Duration(seconds: 5),
  });

  @override
  RouteSettings? redirect(String? route) {
    // Effectuer les vérifications de manière synchrone
    return _checkConnectivity(route);
  }

  RouteSettings? _checkConnectivity(String? route) {
    if (route == offlineRoute) return null;

    // Vérification synchrone de la connectivité
    try {
      final connectivityResult =
          _connectivity.checkConnectivity().then((result) {
        if (result == ConnectivityResult.none) {
          return _handleOffline(route);
        }

        // Vérification Internet
        _internetChecker.hasConnection
            .timeout(
          checkTimeout,
          onTimeout: () => false,
        )
            .then((hasInternet) {
          if (!hasInternet) {
            Get.offNamed(offlineRoute);
          }
        });
      });

      // Si on vient de la page hors-ligne
      if (Get.currentRoute == offlineRoute) {
        final lastRoute = Get.find<RouteHistoryService>().previousRoute;
        return RouteSettings(name: lastRoute ?? '/');
      }

      return null;
    } catch (e) {
      print('Erreur lors de la vérification de la connectivité: $e');
      return _handleOffline(route);
    }
  }

  RouteSettings? _handleOffline(String? route) {
    if (!redirectToOffline) return null;

    // Sauvegarder la route demandée
    if (route != null && route != '/') {
      Get.find<RouteHistoryService>().savePreviousRoute(route);
    }

    return RouteSettings(name: offlineRoute);
  }
}

// Service pour gérer l'historique des routes
class RouteHistoryService extends GetxService {
  String? previousRoute;

  void savePreviousRoute(String route) {
    previousRoute = route;
  }
}
