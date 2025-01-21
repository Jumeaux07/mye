import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/controllers/relation_request_controller.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart' as timeago_fr;
import 'package:transparent_image/transparent_image.dart';

class RelationRequestView extends GetView<RelationRequestController> {
  const RelationRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final profileDetailController = Get.find<ProfileDetailController>();
    timeago.setLocaleMessages('fr', timeago_fr.FrMessages());
    return Scaffold(
      body: homeController.userList.isEmpty
          ? Center(
              child: Text('Aucune demande de connexion'),
            )
          : ListView.builder(
              itemCount: homeController.userList.length,
              itemBuilder: (context, index) {
                final request = homeController.userList[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _buildEnhancedProfileCard(
                      request, profileDetailController),
                );
              },
            ),
    );
  }

  Widget _buildEnhancedProfileCard(
      UserModel user, ProfileDetailController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => controller.showUserOther(user.id.toString()),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar amélioré avec badge de type d'utilisateur
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: ClipOval(
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: user.profileImage ??
                                "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: user.getUserTypeColor(),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Get.isDarkMode
                                  ? Colors.grey[900]!
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            user.getUserTypeIcon(),
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.pseudo ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _buildConnectionButton(
                                RelationRequestController(), user),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Wrap(children: [
                          Flex(
                              mainAxisAlignment: MainAxisAlignment.start,
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  user.secteurActivite ?? "",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ]),
                        ]),
                        const SizedBox(height: 8),
                        _buildUserTags(user),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionButton(
      RelationRequestController controller, UserModel user) {
    return Wrap(children: [
      Icon(
        Icons.close,
        color: Colors.red,
      ),
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    ]);
  }

  Widget _buildUserTags(UserModel user) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (user.getCompetence().length > 0)
            ...user.getCompetence().take(1).map((skill) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          Get.isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  void _handleAccept(UserModel request) {
    // TODO: Implémenter la logique d'acceptation
    print('Demande acceptée: ${request.id}');
  }

  void _handleReject(UserModel request) {
    // TODO: Implémenter la logique de refus
    print('Demande refusée: ${request.id}');
  }
}
