# mye

**Initialiser le gestionnaire**
final permissionManager = PermissionManager();

**Pour une permission spécifique**
bool hasCameraAccess = await permissionManager.handleCameraPermission();

**_Pour vérifier plusieurs permissions en même temps_**
Map<Permission, bool> permissions = await permissionManager.checkEssentialPermissions();

**Pour vérifier des permissions personnalisées**
Map<Permission, bool> customPermissions = await permissionManager.checkAndRequestPermissions([
Permission.camera,
Permission.contacts,
Permission.notification
]);
