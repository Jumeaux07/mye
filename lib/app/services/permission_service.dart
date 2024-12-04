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

  /// Gestionnaire de permissions pour les notifications
  Future<bool> handleNotificationPermission() async {
    return await checkAndRequestPermission(Permission.notification);
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
