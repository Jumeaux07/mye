import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conversation_controller.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/modules/profile_detail/controllers/profile_detail_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/eperienceitem.dart';
import 'package:nom_du_projet/app/widgets/gold_icons.dart';
import 'package:nom_du_projet/app/widgets/skill.dart';

import '../data/constant.dart';

class Detailspageother extends GetView<ProfileDetailController> {
  const Detailspageother({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.showUser(Env.userOther.id.toString());
    final profileRegisterController = Get.find<ProfileregisterController>();
    final dconversationController = Get.find<ConversationController>();
    final homeController = Get.find<HomeController>();
    return RefreshIndicator(
      onRefresh: () async {
        homeController.getAuthUser();
      },
      child: Scaffold(body: Obx(
        () {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (controller.error.value != null) {
            return Center(child: Text(controller.error.value!));
          }
          return CustomScrollView(
            slivers: [
              // En-tête avec image de couverture et photo de profil
              SliverAppBar(
                backgroundColor:
                    Get.isDarkMode ? Colors.grey[850] : Colors.white,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image de couverture
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(Env.userOther.profileImage ??
                                  "https://images.unsplash.com/photo-1732278881253-ed69fb34e01e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyMnx8fGVufDB8fHx8fA%3D%3D"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Photo de profil
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.PROFILEREGISTER);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(Env
                                      .userOther.profileImage ??
                                  "https://images.unsplash.com/photo-1732278881253-ed69fb34e01e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyMnx8fGVufDB8fHx8fA%3D%3D"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),

              // Contenu du profil
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom et titre
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${Env.userOther.prenom ?? Env.userOther.pseudo} ${Env.userOther.nom}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${Env.userOther.secteurActivite}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'À propos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    dconversationController
                                        .openNewDiscussion(Env.userOther);
                                  },
                                  child: GoldIcons(
                                    icon: Icons.chat,
                                  )))
                        ],
                      ),
                      // Informations de base
                      Visibility(
                        replacement: Text("Aucune descriprtion"),
                        visible:
                            Env.userOther.biographie == null ? false : true,
                        child: Card(
                          elevation: 0.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                '${Env.userOther.biographie}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Expérience',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Expérience professionnelle
                      Visibility(
                        replacement: Text("Aucune Expérience"),
                        visible:
                            controller.userOther.value.experiences?.length == 0
                                ? false
                                : true,
                        child: Card(
                          elevation: 0.0,
                          child: Column(
                            // Ajout d'un Column pour contenir la liste
                            children: List.generate(
                              controller.userOther.value.experiences?.length ??
                                  0,
                              (index) => ExperienceItem(
                                company: controller.userOther.value
                                        .experiences?[index].nomEntreprise ??
                                    "",
                                position: controller.userOther.value
                                        .experiences?[index].poste ??
                                    "",
                                period:
                                    "${controller.userOther.value.experiences?[index].dateDebut ?? ""} - ${controller.userOther.value.experiences?[index].dateFin ?? ""}", // Correction : dateDebut -> dateFin
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                'Compétences',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Compétences
                      Visibility(
                        replacement: Text("Aucune compétence"),
                        visible: Env.userOther.getCompetence().length == 0
                            ? false
                            : true,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      Env.userOther.getCompetence().length,
                                  shrinkWrap: true,
                                  // padding: EdgeInsets.all(10),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SkillChip(
                                          Env.userOther.getCompetence()[index]),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      )),
    );
  }
}
