import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/Conversation/views/conversation_view.dart';
import 'package:nom_du_projet/app/modules/abonnement/views/abonnement_view.dart';
import 'package:nom_du_projet/app/modules/notification/controllers/notification_controller.dart';

import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/views/relation_request_view.dart';

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/accueil_page.dart';
import '../../../widgets/searchuser.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final profileDetailController = Get.find<ProfileDetailController>();
    final notificationController = Get.find<NotificationController>();
    TextEditingController query = TextEditingController();
    return Obx(() => Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            currentIndex: controller.selectedIndex.value,
            onTap: (value) => controller.selectedIndex(value),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group_add),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.share_location_rounded),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: "",
              ),
            ],
          ),
          appBar: AppBar(
            title: Text(
              "${controller.selectedIndex.value == 0 ? "Mye" : controller.selectedIndex.value == 1 ? "Demandes de connexion" : controller.selectedIndex.value == 2 ? "Aproximité" : controller.selectedIndex.value == 3 ? "Conversation" : ""}",
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black),
            ),
            elevation: 1,
            backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  Get.toNamed(Routes.PROFILE_DETAIL);
                },
                child: ClipOval(
                  child: Image.network(
                    Env.userAuth.profileImage ??
                        "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person);
                    },
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                splashRadius: 24,
                icon: Badge(
                  isLabelVisible:
                      notificationController.totalNotifcation.value > 0,
                  label: Text(
                    notificationController.totalNotifcation.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Icon(
                    Icons.notifications,
                    size: 26,
                    color: yellowColor,
                  ),
                ),
                onPressed: () {
                  // Changé de onTap à onPressed
                  Get.toNamed(Routes.NOTIFICATION);
                },
              ),
              IconButton(
                splashRadius: 24,
                icon: Icon(Icons.settings, size: 26, color: yellowColor),
                onPressed: () {
                  // Changé de onTap à onPressed
                  Get.toNamed(Routes.SETTING);
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: controller.selectedIndex.value == 0
              ? Accueil()
              : controller.selectedIndex.value == 1
                  ? RelationRequestView()
                  : controller.selectedIndex.value == 2
                      ? NearbyUsersMap()
                      : Env.userAuth.isPremium == 0
                          ? AbonnementView()
                          : ConversationView(),
        ));
  }
}
