import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/widgets/goldbuttonlight.dart';

import 'app/data/constant.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/detailprofile.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // États pour les différents paramètres
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _darkMode = false;
  bool _locationEnabled = true;
  String _selectedLanguage = 'Français';

  // Options de langue disponibles
  final List<String> _languages = ['Français', 'English', 'Español', 'Deutsch'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: ListView(
        children: [
          // Section Profil
          _buildSection(
            'Profil',
            [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg'),
                  radius: 25,
                ),
                title: Text('Jean Dupont'),
                subtitle: Text('jean.dupont@email.com'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigation vers édition du profil
                  Get.to(() => ProfileDetailScreen());
                },
              ),
            ],
          ),

          // Section Notifications
          _buildSection(
            'Notifications',
            [
              SwitchListTile(
                title: Text('Notifications push'),
                subtitle: Text('Recevoir des notifications sur votre appareil'),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Notifications par email'),
                subtitle: Text('Recevoir des mises à jour par email'),
                value: _emailNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
            ],
          ),

          // Section Apparence
          _buildSection(
            'Apparence',
            [
              SwitchListTile(
                title: Text('Mode sombre'),
                subtitle: Text('Activer le thème sombre'),
                value: _darkMode,
                onChanged: (bool value) {
                  setState(() {
                    _darkMode = value;
                  });
                },
              ),
              // ListTile(
              //   title: Text('Langue'),
              //   subtitle: Text(_selectedLanguage),
              //   trailing: Icon(Icons.chevron_right),
              //   onTap: () {
              //     _showLanguageDialog();
              //   },
              // ),
            ],
          ),

          // Section Confidentialité
          _buildSection(
            'Confidentialité',
            [
              // SwitchListTile(
              //   title: Text('Localisation'),
              //   subtitle: Text('Autoriser l\'accès à votre position'),
              //   value: _locationEnabled,
              //   onChanged: (bool value) {
              //     setState(() {
              //       _locationEnabled = value;
              //     });
              //   },
              // ),
              ListTile(
                title: Text('Données personnelles'),
                subtitle: Text('Gérer vos données personnelles'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigation vers gestion des données
                },
              ),
            ],
          ),

          // Section Compte
          _buildSection(
            'Compte',
            [
              ListTile(
                title: Text('Changer le mot de passe'),
                leading: Icon(Icons.lock_outline),
                onTap: () {
                  // TODO: Navigation vers changement de mot de passe
                },
              ),
              ListTile(
                title: Text('Abonnement'),
                leading: Icon(Icons.card_membership),
                subtitle: Text('Premium'),
                onTap: () {
                  // TODO: Navigation vers gestion de l'abonnement
                },
              ),
              ListTile(
                title: Text('Supprimer le compte'),
                leading: Icon(Icons.delete_outline, color: Colors.red),
                onTap: () {
                  _showDeleteAccountDialog();
                },
              ),
            ],
          ),

          // Section À propos
          _buildSection(
            'À propos',
            [
              ListTile(
                title: Text('Version de l\'application'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                title: Text('Conditions d\'utilisation'),
                onTap: () {
                  // TODO: Navigation vers conditions d'utilisation
                },
              ),
              ListTile(
                title: Text('Politique de confidentialité'),
                onTap: () {
                  // TODO: Navigation vers politique de confidentialité
                },
              ),
            ],
          ),

          // Bouton de déconnexion
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: GoldButtonLight(
                isLoading: false,
                label: "Se déconnecter",
                onTap: () => _showLogoutDialog(),
              )),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        ...children,
        Divider(),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir la langue'),
          content: SingleChildScrollView(
            child: ListBody(
              children: _languages.map((String language) {
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer le compte'),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // TODO: Implémenter la suppression du compte
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Se déconnecter'),
          content: Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Se déconnecter'),
              onPressed: () {
                box.erase();
                Get.offAllNamed(Routes.LOGIN);
              },
            ),
          ],
        );
      },
    );
  }
}
