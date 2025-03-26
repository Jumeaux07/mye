import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/relation_model.dart';
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
    final profileDetailController = Get.find<ProfileDetailController>();
    timeago.setLocaleMessages('fr', timeago_fr.FrMessages());

    return Obx(
      () => RefreshIndicator(
        onRefresh: () {
          controller.getRequest();

          return Future.delayed(const Duration(seconds: 1));
        },
        child: Scaffold(
            body: controller.requestUser.isEmpty
                ? Center(
                    child: Text('Aucune demande de connexion'),
                  )
                : controller.obx(
                    (data) => ListView.builder(
                      itemCount: controller.requestUser.length,
                      itemBuilder: (context, index) {
                        final request = controller.requestUser[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: _buildEnhancedProfileCard(
                              request, profileDetailController),
                        );
                      },
                    ),
                    onLoading: Center(
                      child: CircularProgressIndicator(),
                    ),
                    onEmpty: Center(child: Text('Aucune demande de connexion')),
                    onError: (error) => Text("${error}"),
                  )),
      ),
    );
  }

  Widget _buildEnhancedProfileCard(
      RelationModel relation, ProfileDetailController controller) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () =>
            controller.showUserOther(relation.getRelation().id.toString()),
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
                            image: relation.getRelation().profileImage ??
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
                            color: relation.getRelation().getUserTypeColor(),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Get.isDarkMode
                                  ? Colors.grey[900]!
                                  : Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            relation.getRelation().getUserTypeIcon(),
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
                                relation.getRelation().pseudo ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            _buildConnectionButton(
                              RelationRequestController(),
                              relation.getRelation(),
                              () => controller.showUserOther(
                                  relation.getRelation().id.toString()),
                              () => RelationRequestController()
                                  .sendResponseRequest(
                                      "accepted", relation.id.toString()),
                              () => RelationRequestController()
                                  .sendResponseRequest(
                                      "rejected", relation.id.toString()),
                            )
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
                                  relation.getRelation().secteurActivite ?? "",
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.grey[600],
                                  ),
                                ),
                              ]),
                        ]),
                        const SizedBox(height: 8),
                        _buildUserTags(relation.getRelation()),
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
      RelationRequestController controller,
      UserModel user,
      void Function()? voir,
      void Function()? accpter,
      void Function()? refuser) {
    return Wrap(children: [
      InkWell(
        onTap: refuser,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
      ),
      SizedBox(
        width: 8,
      ),
      InkWell(
        onTap: accpter,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        ),
      ),
      SizedBox(
        width: 8,
      ),
      InkWell(
        onTap: voir,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.remove_red_eye,
              color: Colors.black,
            ),
          ),
        ),
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
