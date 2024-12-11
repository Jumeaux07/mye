import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/custombuttonsimple.dart';

import '../../../data/constant.dart';
import '../../../widgets/custom_alert.dart';
import '../../../widgets/customtagtextfield.dart';
import '../../../widgets/eperienceitem.dart';
import '../../../widgets/gold_icons.dart';
import '../../../widgets/skill.dart';
import '../controllers/profile_detail_controller.dart';

class ProfileDetailView extends GetView<ProfileDetailController> {
  const ProfileDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    final profileregisterController = Get.put(ProfileregisterController());
    return RefreshIndicator(
      onRefresh: () async {
        controller.showUser(controller.user.value.id.toString());
      },
      child: Scaffold(
          body: controller.obx(
        (data) => CustomScrollView(
          slivers: [
            // En-tête avec image de couverture et photo de profil
            SliverAppBar(
              backgroundColor: Get.isDarkMode ? Colors.grey[850] : Colors.white,
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
                            image: NetworkImage(controller
                                    .user.value.profileImage ??
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
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(controller
                                  .user.value.profileImage ??
                              "https://images.unsplash.com/photo-1732278881253-ed69fb34e01e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyMnx8fGVufDB8fHx8fA%3D%3D"),
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
                    GestureDetector(
                      onTap: () {
                        profileregisterController.cleanImagebase64();
                        if (box.read("id").toString() ==
                            controller.user.value.id.toString()) {
                          controller.showUserToEdit(
                              controller.user.value.id.toString());
                          Get.toNamed(Routes.PROFILEREGISTER);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.user.value.prenom ?? controller.user.value.pseudo} ${controller.user.value.nom}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${controller.user.value.secteurActivite}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          box.read("id").toString() !=
                                  controller.user.value.id.toString()
                              ? GoldIcons(
                                  icon: Icons.chat,
                                )
                              : GoldIcons(
                                  icon: Icons.edit,
                                )
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    Text(
                      'À propos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Informations de base
                    Visibility(
                      replacement: Text("Aucune descriprtion"),
                      visible: controller.user.value.biographie == null
                          ? false
                          : true,
                      child: Card(
                        elevation: 0.0,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                '${controller.user.value.biographie}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),
                    Text(
                      'Expérience',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Expérience professionnelle
                    Visibility(
                      replacement: Text("Aucune Expérience"),
                      visible: controller.user.value.experiences?.length == 0
                          ? false
                          : true,
                      child: Card(
                          elevation: 0.0,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(16),
                            itemCount:
                                controller.user.value.experiences?.length ?? 0,
                            itemBuilder: (context, index) {
                              return ExperienceItem(
                                company: controller.user.value
                                        .experiences?[index].nomEntreprise ??
                                    "",
                                position: controller
                                        .user.value.experiences?[index].poste ??
                                    "",
                                period:
                                    "${controller.user.value.experiences?[index].dateDebut ?? ""} - ${controller.user.value.experiences?[index].dateDebut}",
                              );
                            },
                          )),
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
                        Expanded(
                          child: SizedBox(
                              height: 50,
                              child: GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                    title: "Compétences",
                                    content: Column(
                                      children: [
                                        TagTextField(
                                          onTagsChanged: (tags) {
                                            controller.update(tags);
                                            // Faire quelque chose avec les tags
                                            print('Tags actuels : $tags');
                                          },
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        CustomButton(
                                          onPressed: () {
                                            controller.updateSkill();
                                          },
                                          enabled: controller.tags.isNotEmpty,
                                          label: "Valider",
                                        )
                                      ],
                                    ),
                                  );
                                },
                                child: Visibility(
                                  visible: box.read("id").toString() !=
                                          controller.user.value.id.toString()
                                      ? false
                                      : true,
                                  child: GoldIcons(
                                    icon: Icons.edit,
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                    // Compétences
                    Visibility(
                      replacement: Text("Aucune compétence"),
                      visible: controller.user.value.getCompetence().length == 0
                          ? false
                          : true,
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 100,
                              child: Card(
                                  elevation: 0.0,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.user.value
                                        .getCompetence()
                                        .length,
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(16),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SkillChip(controller.user.value
                                            .getCompetence()[index]),
                                      );
                                    },
                                  )),
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
        ),
        onLoading: Center(
          child: CircularProgressIndicator(),
        ),
        onError: (error) {
          return CustomAlertDialog(
              message: "$error",
              onPressed: () {
                controller.showUser("${box.read("user_id_show")}");
              },
              showAlertIcon: true);
        },
      )),
    );
  }
}
