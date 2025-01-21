import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Singleton pattern
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Vérifie et demande plusieurs permissions en même temps
  Future<Map<Permission, bool>> checkAndRequestPermissions(
      List<Permission> permissions) async {
    Map<Permission, bool> statuses = {};

    for (Permission permission in permissions) {
      final status = await checkAndRequestPermission(permission);
      statuses[permission] = status;
    }

    return statuses;
  }

  /// Vérifie et demande une permission spécifique
  Future<bool> checkAndRequestPermission(Permission permission) async {
    // Vérifie si la permission est déjà accordée
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    // Si la permission a été refusée définitivement
    if (status.isPermanentlyDenied) {
      // Ouvre les paramètres de l'application
      await openAppSettings();
      return false;
    }

    // Demande la permission
    final result = await permission.request();
    return result.isGranted;
  }

  /// Vérifie si une permission est accordée
  Future<bool> hasPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Gestionnaire de permissions pour la caméra
  Future<bool> handleCameraPermission() async {
    return await checkAndRequestPermission(Permission.camera);
  }

  /// Gestionnaire de permissions pour le stockage
  Future<bool> handleStoragePermission() async {
    return await checkAndRequestPermission(Permission.storage);
  }

  /// Gestionnaire de permissions pour la localisation
  Future<bool> handleLocationPermission() async {
    return await checkAndRequestPermission(Permission.location);
  }

  /// Gestionnaire de permissions pour le microphone
  Future<bool> handleMicrophonePermission() async {
    return await checkAndRequestPermission(Permission.microphone);
  }

  /// Gestionnaire de permissions pour les contacts
  Future<bool> handleContactsPermission() async {
    return await checkAndRequestPermission(Permission.contacts);
  }

  Future<bool> handleNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    try {
      // Demande des permissions Firebase
      NotificationSettings settings = await messaging.requestPermission(
          alert: true, badge: true, sound: true, provisional: false);

      print('Status des permissions Firebase: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Pour iOS, vérifier d'abord le token APNS
        if (Platform.isIOS) {
          print('Attente du token APNS...');
          String? apnsToken;

          for (int i = 0; i < 5; i++) {
            apnsToken = await messaging.getToken();
            if (apnsToken != null) {
              box.write("fcm_token", apnsToken);
              print('APNS Token obtenu: $apnsToken');
              break;
            }
            await Future.delayed(Duration(seconds: 1));
          }

          if (apnsToken == null) {
            print(
                'Impossible d\'obtenir le token APNS après plusieurs tentatives');
            return false;
          }
        }

        // Récupération du token FCM dans une boucle séparée
        String? fcmToken;
        for (int i = 0; i < 5; i++) {
          fcmToken = await messaging.getToken();
          if (fcmToken != null) {
            print('FCM Token obtenu: $fcmToken');
            box.write("fcm_token", fcmToken);
            break;
          }
          await Future.delayed(Duration(seconds: 1));
        }

        if (fcmToken == null) {
          print(
              'Impossible d\'obtenir le token FCM après plusieurs tentatives');
          return false;
        }

        // Vérification des permissions système
        if (await checkAndRequestPermission(Permission.notification)) {
          print('Toutes les permissions sont accordées');
          return true;
        }
      }

      print('Permissions refusées ou incomplètes');
      return false;
    } catch (e) {
      print('Erreur lors de la demande de permissions: $e');
      return false;
    }
  }

  /// Vérifie toutes les permissions essentielles de l'application
  Future<Map<Permission, bool>> checkEssentialPermissions() async {
    return await checkAndRequestPermissions([
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.microphone,
    ]);
  }
}
