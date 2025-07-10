import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/Conversation/views/conversation_view.dart';
import 'package:nom_du_projet/app/modules/abonnement/views/abonnement_view.dart';
import 'package:nom_du_projet/app/pagerelation.dart';

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/accueil_page.dart';
import '../../../widgets/searchuser.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
            currentIndex: controller.selectedIndex.value,
            onTap: (value) => controller.selectedIndex(value),
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Accueil",
              ),
              BottomNavigationBarItem(
                icon: Badge(
                    isLabelVisible: Env.connectionCount > 0,
                    label: Text(
                      Env.connectionCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Icon(Icons.group_add)),
                label: "Réseaux",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.share_location_rounded),
                label: "Proximité",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: "Discussions",
              ),
            ],
          ),
          appBar: AppBar(
            title: Text(
              "${controller.selectedIndex.value == 0 ? "${Env.userAuth.getFullName()}" : controller.selectedIndex.value == 1 ? "Réseaux" : controller.selectedIndex.value == 2 ? "Proximité" : controller.selectedIndex.value == 3 ? "Discussions" : ""}",
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black),
            ),
            elevation: 1,
            backgroundColor: Get.isDarkMode ? Colors.black : Colors.amber[100],
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
                  backgroundColor: Colors.redAccent,
                  isLabelVisible: Env.notificationnCount > 0,
                  label: Text(
                    Env.notificationnCount.toString(),
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
                  ? Pagerelation()
                  : controller.selectedIndex.value == 2
                      ? NearbyUsersMap()
                      : Env.userAuth.isPremium == 0
                          ? AbonnementView()
                          : ConversationListView(),
        ));
  }
}
