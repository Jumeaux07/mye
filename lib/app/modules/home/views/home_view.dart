import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';

import '../../../data/constant.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/accueil_page.dart';
import '../../../widgets/duscusion.dart';
import '../../../widgets/gold_icons.dart';
import '../../abonnement/views/abonnement_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final profileDetailController = Get.find<ProfileDetailController>();
    // profileDetailController.showUser(Env.userAuth.id.toString());
    return Obx(() => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: controller.selectedIndex.value,
          onTap: (value) => controller.selectedIndex(value),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Accueil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payment),
              label: "Abonnement",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Echanges",
            ),
          ],
        ),
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.toNamed(Routes.PROFILE_DETAIL);
            },
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                controller.user.value.profileImage ??
                    "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996",
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                Get.toNamed(Routes.SETTING);
              },
              child: GoldIcons(size: 30, icon: Icons.settings),
            ),
            SizedBox(
              width: 15,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.NOTIFICATION);
              },
              child: GoldIcons(
                size: 30,
                icon: Icons.notifications,
              ),
            ),
          ],
          title: Text("${Env.userAuth.pseudo ?? ""}! 👋"),
          centerTitle: true,
        ),
        body: controller.selectedIndex.value == 0
            ? Accueil()
            : controller.selectedIndex.value == 1
                ? AbonnementView()
                : DiscussionsView()));
  }
}
