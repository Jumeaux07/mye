import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conversation_controller.dart';
import 'package:nom_du_projet/app/modules/Login/views/login_view.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/controllers/relation_request_controller.dart';
import 'package:nom_du_projet/app/modules/setting/views/facture.dart';
import 'package:nom_du_projet/app/widgets/customPasswordTextField.dart';
import 'package:http/http.dart' as http;

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../../profile_detail/controllers/profile_detail_controller.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    final profiledetailController = Get.find<ProfileDetailController>();
    final homeController = Get.find<HomeController>();
    return Obx(() => Scaffold(
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
                      backgroundImage: NetworkImage(Env.userAuth.profileImage ??
                          'https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996'),
                      radius: 25,
                    ),
                    title: Text("${Env.userAuth.getFullName()}"),
                    subtitle: Text(Env.userAuth.email ?? ""),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigation vers édition du profil
                      Get.toNamed(Routes.PROFILE_DETAIL);
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
                    subtitle:
                        Text('Recevoir des notifications sur votre appareil'),
                    value: controller.notificationsEnabled.value,
                    onChanged: (bool value) {
                      controller.setNotificationsEnabled(value);
                    },
                  ),
                  SwitchListTile(
                    title: Text('Notifications par email'),
                    subtitle: Text('Recevoir des mises à jour par email'),
                    value: controller.emailNotifications.value,
                    onChanged: (bool value) {
                      controller.setEmailNotifications(value);
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
                    value: controller.darkMode.value,
                    onChanged: (bool value) {
                      controller.setDarkMode(value);
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
              // _buildSection(
              //   'Confidentialité',
              //   [
              //     // SwitchListTile(
              //     //   title: Text('Localisation'),
              //     //   subtitle: Text('Autoriser l\'accès à votre position'),
              //     //   value: _locationEnabled,
              //     //   onChanged: (bool value) {
              //     //     setState(() {
              //     //       _locationEnabled = value;
              //     //     });
              //     //   },
              //     // ),
              //     ListTile(
              //       title: Text('Données personnelles'),
              //       subtitle: Text('Gérer vos données personnelles'),
              //       trailing: Icon(Icons.chevron_right),
              //       onTap: () {
              //         // TODO: Navigation vers gestion des données
              //       },
              //     ),
              //   ],
              // ),

              // Section Compte
              _buildSection(
                'Compte',
                [
                  ListTile(
                    title: Text('Changer le mot de passe'),
                    leading: Icon(Icons.lock_outline),
                    onTap: () {
                      // TODO: Navigation vers changement de mot de passe
                      Get.defaultDialog(
                        title: "Changer le mot de passe",
                        content: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              //Ancien
                              Custompasswordtextfield(
                                label: "Mot de passe actuel",
                                passwordController:
                                    controller.lastPasswordController.value,
                                validator: (validate) {
                                  if (validate == '') {
                                    return "l'ancien de mot de passe est obligatoire";
                                  }

                                  if (validate!.length < 8) {
                                    return "Le mot de passe doit être de 8 caractères minimum";
                                  }
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //Nouveau mot de passe
                              Custompasswordtextfield(
                                label: "Nouveau mot de passe",
                                passwordController:
                                    controller.passwordController.value,
                                validator: (validate) {
                                  if (validate == '') {
                                    return "le nouveau de mot de passe est obligatoire";
                                  }

                                  if (validate!.length < 8) {
                                    return "Le mot de passe doit être de 8 caractères minimum";
                                  }
                                },
                              ),

                              SizedBox(
                                height: 5,
                              ),
                              //Nouveau mot de passe
                              Custompasswordtextfield(
                                label: "Confirmation",
                                passwordController: controller
                                    .passwordConfirmationController.value,
                                validator: (validate) {
                                  if (validate !=
                                      controller
                                          .passwordController.value.text) {
                                    return "Le mot de mot de passe ne correspond pas";
                                  }
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Obx(() => GoldButtonLight(
                                    isLoading: controller.isLoading.value,
                                    label: "Valider",
                                    onTap: () {
                                      controller.updatePassword(
                                          controller.lastPasswordController
                                              .value.text,
                                          controller
                                              .passwordController.value.text);
                                    },
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Abonnement'),
                    leading: Icon(Icons.card_membership),
                    subtitle: Text(
                        "${Env.userAuth.isPremium == 1 ? "Preminum" : "Gratuit"}"),
                    onTap: () {
                      // TODO: Navigation vers gestion de l'abonnement
                      if (true) {
                        Get.to(() => AbonnementView());
                      }
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
                    subtitle: Text('${box.read("version") ?? "1.0"}'),
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
        ));
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
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choisir la langue'),
          content: SingleChildScrollView(
            child: ListBody(
              children: controller.languages.map((String language) {
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    controller.setLanguage(language);
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
      context: Get.context!,
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
                // Exemple avec méthode POST (à adapter selon l'API)
                http.post(
                  Uri.parse('https://api-mye.cefir.tech/api/delete-account'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Authorization':
                        'Bearer ${box.read("token")}', // si nécessaire
                  },
                ).then((response) {
                  if (response.statusCode == 200) {
                    // Suppression réussie
                    Navigator.of(context).pop(); // Fermer la boîte de dialogue
                    Env.userAuth = UserModel();
                    Env.userOther = UserModel();
                    Env.connectionCount = 0;
                    final fcmtoken = box.read("fcm_token");
                    box.erase();
                    Get.offAllNamed(Routes.LOGIN);
                    box.write("fcm_token", fcmtoken);
                    Get.find<HomeController>().resetData();
                    Get.find<ConversationController>().resetData();
                    Get.find<RelationRequestController>().resetData();
                    // Affiche un message ou redirige
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Compte supprimé avec succès')),
                    );
                  } else {
                    // Erreur lors de la suppression
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : ${response.body}')),
                    );
                  }
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur réseau : $error')),
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: Get.context!,
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
                Env.userAuth = UserModel();
                Env.userOther = UserModel();
                Env.connectionCount = 0;
                final fcmtoken = box.read("fcm_token");
                box.erase();
                Get.offAllNamed(Routes.LOGIN);
                box.write("fcm_token", fcmtoken);
                Get.find<HomeController>().resetData();
                Get.find<ConversationController>().resetData();
                Get.find<RelationRequestController>().resetData();
              },
            ),
          ],
        );
      },
    );
  }
}
