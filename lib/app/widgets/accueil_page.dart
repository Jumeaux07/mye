import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:nom_du_projet/app/data/auth_provider.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conversation_controller.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/controllers/relation_request_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/shinerloading.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Accueil extends GetView<HomeController> {
  Accueil({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  final _authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final profiledetailController = Get.find<ProfileDetailController>();
    final profileRegisterController = Get.find<ProfileregisterController>();
    final relationController = Get.find<RelationRequestController>();

    if (box.read("fcm_token") != "null" || box.read("fcm_token") != null) {
      FirebaseMessaging.instance.getToken().then((value) {
        box.write("fcm_token", value);
        _authProvider.updateFcmToken(value ?? "");
      });
    }

    Future.delayed(Duration(seconds: 1), () {
      relationController.getRelation();
      relationController..getRequestSend();
      controller.getAuthUser();
      controller.getAllUser();
      profileRegisterController.getSecteur();
      // controller.getPub();
    });
    // relationController.getRequest();

    return RefreshIndicator(
        onRefresh: () async {
          await relationController
            ..getRequestSend();
          relationController.getRelation();
          await controller.getAuthUser();
          await controller.getAllUser();
          await profileRegisterController.getSecteur();
          // controller.getPub();
        },
        child: Obx(
          () => Container(
            color: Colors.amber.shade100,
            child: Padding(
              padding: EdgeInsets.only(top: 1),
              child: Container(
                padding: EdgeInsets.only(top: 25),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // décalage vertical de l'ombre
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: ListView(
                  children: [
                    //Si user n est pas encore actif, on affiche un messaage d appel a l action
                    Env.userAuth.isActive == 1
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Get.toNamed(Routes.PROFILE_DETAIL);
                            },
                            child: FadeTransition(
                              opacity: controller.animation,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "Veuillez complèter vos informations svp",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),

                    // Bannière d'événements/actualités
                    Visibility(
                      visible: controller.pubList.isNotEmpty,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 150,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        items: controller.pubList
                            .map((pub) => _buildCarouselItem(
                                pub.titre ?? "",
                                pub.description ?? "",
                                pub.url ?? "",
                                pub.urlimage ?? ""))
                            .toList(),
                      ),
                    ),

                    // Section de recherche améliorée
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        children: [
                          // Barre de recherche existante
                          _buildSearchBar(searchController, controller),

                          // Suggestions de recherche rapide
                          const SizedBox(height: 8),
                          Visibility(
                            visible: profileRegisterController
                                .secteursList.isNotEmpty,
                            child: SizedBox(
                              height: 50,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: () {
                                  profileRegisterController.secteursList
                                      .shuffle();
                                  return profileRegisterController.secteursList
                                      .take(4)
                                      .map((secteur) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: _buildQuickSearchChip(
                                                secteur.libelle ?? ""),
                                          ))
                                      .toList();
                                }(),
                              ),
                            ),
                          )
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
                          _buildSectionHeader("Suggestions"),
                          controller.obx(
                            onEmpty: Center(
                              child: Text("Aucun resultat"),
                            ),
                            onError: (error) => Center(
                              child: Text("Erreur réseau, actualisez la page."),
                            ),
                            onLoading: Center(
                              child: ShimmerLoading(),
                              // child: CircularProgressIndicator(),
                            ),
                            (data) => controller.userList.isEmpty
                                ? Center(
                                    child: Text("Aucune donnée"),
                                  )
                                : ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.userList.length,
                                    itemBuilder: (context, index) =>
                                        _buildEnhancedProfileCard(
                                            controller.userList[index],
                                            profiledetailController,
                                            relationController),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
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
              fontSize: 18, color: Color.fromARGB(255, 117, 115, 115)),
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
      UserModel user,
      ProfileDetailController controller,
      RelationRequestController relationRequestController) {
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
                            Obx(
                              () => _buildConnectionButton(
                                  conversationController,
                                  user,
                                  relationRequestController),
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

  Widget _buildConnectionButton(ConversationController controller,
      UserModel user, RelationRequestController relationController) {
    return (relationController.isLoading.value &&
            relationController.currentLoadingUserId.value == user.id)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : TextButton.icon(
            style: ButtonStyle(
                iconColor: WidgetStatePropertyAll(Colors.black),
                foregroundColor: WidgetStatePropertyAll(Colors.black),
                backgroundColor: WidgetStatePropertyAll(Colors.amber[100])),
            onPressed: () {
              if ((relationController.requestUser
                      .where((el) => (el.receiver?.id == user.id ||
                          el.sender?.id == user.id))
                      .isNotEmpty ||
                  relationController.connectionUsers
                      .where((el) => el.connectedUser?.id == user.id)
                      .isNotEmpty ||
                  relationController.requestUserSend
                      .where((el) => (el.receiver?.id == user.id ||
                          el.sender?.id == user.id))
                      .isNotEmpty)) {
                if (Env.userAuth.isPremium == 0) {
                  Get.toNamed(Routes.ABONNEMENT);
                } else {
                  controller.hasConversation(user);
                  // controller.openNewDiscussion(user);
                }
              } else {
                relationController.sendRequest(user.id.toString());
              }
            },
            icon: (relationController.requestUser
                        .where((el) => (el.receiver?.id == user.id ||
                            el.sender?.id == user.id))
                        .isNotEmpty ||
                    relationController.connectionUsers
                        .where((el) => el.connectedUser?.id == user.id)
                        .isNotEmpty ||
                    relationController.requestUserSend
                        .where((el) => (el.receiver?.id == user.id ||
                            el.sender?.id == user.id))
                        .isNotEmpty)
                ? const Icon(Icons.send)
                : const Icon(Icons.person_add),
            label: Text(
                "${relationController.requestUser.where((el) => (el.receiver?.id == user.id || el.sender?.id == user.id)).isNotEmpty || relationController.connectionUsers.where((el) => el.connectedUser?.id == user.id).isNotEmpty || relationController.requestUserSend.where((el) => (el.receiver?.id == user.id || el.sender?.id == user.id)).isNotEmpty ? "Message" : "Ajouter"} "),
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

  // Ajout de la méthode _buildQuickSearchChip
  Widget _buildQuickSearchChip(String label) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: Get.isDarkMode ? Colors.white : Colors.black87,
          fontSize: 12,
        ),
      ),
      backgroundColor: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
      onPressed: () {
        controller.search(label);
        // Implémentez ici la logique de recherche rapide
      },
      elevation: 0,
      pressElevation: 2,
    );
  }
}
