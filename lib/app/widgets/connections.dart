import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conversation_controller.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/controllers/relation_request_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Connections extends GetView<RelationRequestController> {
  const Connections({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profiledetailController = Get.find<ProfileDetailController>();

    // controller.getRelation();

    return RefreshIndicator(
      onRefresh: () async {
        controller.getRelation();
        controller.getRequest();
      },
      child: ListView(
        children: [
          // Section de recherche améliorée
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Suggestions de recherche rapide
                const SizedBox(height: 8),
              ],
            ),
          ),

          // Section "Découvrir"
          // _buildDiscoverSection(),

          // Liste des profils améliorée
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Relations"),
                controller.obx(
                  onEmpty: Center(
                    child: Text("Aucun resultat"),
                  ),
                  onError: (error) => Center(
                    child: Text(error.toString()),
                  ),
                  onLoading: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  (data) => controller.connectionUsers.isEmpty
                      ? Center(
                          child: Text("Aucune donnée"),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.connectionUsers.length,
                          itemBuilder: (context, index) =>
                              _buildEnhancedProfileCard(
                            controller.connectionUsers[index].connectedUser ??
                                UserModel(),
                            profiledetailController,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(
      String title, String subtitle, String url, String imageUrl) {
    return InkWell(
      onTap: () {
        if (url.isNotEmpty || url != "") {
          _launchURL(url);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: yellowColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: yellowColor.withOpacity(0.3)),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: imageUrl != ""
                  ? Visibility(
                      visible: imageUrl != "",
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.3),
                        colorBlendMode: BlendMode.darken,
                      ),
                    )
                  : Container(
                      color: Colors.black,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  url == ""
                      ? ElevatedButton(
                          onPressed: () {
                            if (url.isNotEmpty || url != "") {
                              _launchURL(url);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.8),
                          ),
                          child: Text(
                            "En savoir plus",
                            style: TextStyle(color: yellowColor),
                          ),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Votre réseau",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Vues du profil", "127"),
              _buildStatItem("Connexions", "354"),
              _buildStatItem("Recherches", "48"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Get.isDarkMode ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildDiscoverCard(
            "Entreprises\nà proximité",
            Icons.business,
            Colors.blue,
          ),
          _buildDiscoverCard(
            "Offres\nd'emploi",
            Icons.work,
            Colors.green,
          ),
          _buildDiscoverCard(
            "Événements\nà venir",
            Icons.event,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  // Ajout de la méthode _buildSectionHeader
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: Get.isDarkMode ? Colors.grey[700] : Colors.grey[300],
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoverCard(String title, IconData icon, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
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
                                conversationController, user),
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
      ConversationController controller, UserModel user) {
    return OutlinedButton.icon(
      onPressed: () {
        if (Env.userAuth.isPremium == 0) {
          Get.toNamed(Routes.ABONNEMENT);
        } else {
          controller.openNewDiscussion(user);
        }
      },
      icon: const Icon(Icons.send),
      label: const Text("Message"),
    );
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

  // Ajout de la méthode _buildSearchBar
  Widget _buildSearchBar(
      TextEditingController controller, HomeController homeController) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
                onTap: () => homeController.search(controller.text),
                child: Icon(Icons.search, color: Colors.grey)),
          ),
          Expanded(
            child: TextField(
              onSubmitted: (value) {
                homeController.search(controller.text);
              },
              controller: controller,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Rechercher des contacts, entreprises...",
                hintStyle: TextStyle(fontSize: 14),
              ),
              onChanged: (value) {
                // Implémentez ici la logique de recherche
              },
            ),
          ),
        ],
      ),
    );
  }
}
