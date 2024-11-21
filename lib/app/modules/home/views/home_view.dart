import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/setting.dart';

import '../../../data/constant.dart';
import '../../../widgets/accueil_page.dart';
import '../../../widgets/gold_icons.dart';
import '../../../widgets/message.dart';
import '../../../widgets/notifications.dart';
import '../../abonnement/views/abonnement_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () {
                Get.to(() => SettingsView());
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg"),
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Get.to(() => NotificationsView());
                },
                child: GoldIcons(
                  size: 30,
                  icon: Icons.notifications,
                ),
              ),
            ],
            title: Text("Bienvenue ${box.read("username") ?? ""}! 👋"),
            centerTitle: true,
          ),
          body: controller.selectedIndex.value == 0
              ? Accueil()
              : controller.selectedIndex.value == 1
                  ? AbonnementView()
                  : ChatView(
                      currentUserId: '12',
                      recipientId: '21',
                      recipientName: 'Essis',
                    ),
        ));
  }
}
