import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:nom_du_projet/app/modules/Profileregister/controllers/profileregister_controller.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/CustomTextField.dart';
import 'package:nom_du_projet/app/widgets/custombuttonsimple.dart';

import '../../../data/constant.dart';
import '../../../data/models/position_model.dart';
import '../../../data/models/secteur_model.dart';
import '../../../widgets/customDateField.dart';
import '../../../widgets/customtagtextfield.dart';
import '../../../widgets/eperienceitem.dart';
import '../../../widgets/gold_icons.dart';
import '../../../widgets/skill.dart';
import '../controllers/profile_detail_controller.dart';

class ProfileDetailView extends GetView<ProfileDetailController> {
  const ProfileDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.showUser(Env.userAuth.id.toString());
    final profileRegisterController = Get.find<ProfileregisterController>();
    final homeController = Get.find<HomeController>();
    final _formKey = GlobalKey<FormState>();
    final _formKeyExperience = GlobalKey<FormState>();
    final _formKeyCompetence = GlobalKey<FormState>();
    final _formKeyBio = GlobalKey<FormState>();
    controller.bio.value.text = Env.userAuth.biographie ?? "";
    profileRegisterController.nomController.value.text = Env.userAuth.nom ?? "";
    profileRegisterController.prenomController.value.text =
        Env.userAuth.prenom ?? "";
    profileRegisterController.secteurController.value.text =
        Env.userAuth.secteurActivite ?? "";
    profileRegisterController.adresseController.value.text =
        Env.userAuth.adresseGeographique ?? "";

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
                              image: NetworkImage(Env.userAuth.profileImage ??
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
                                      .userAuth.profileImage ??
                                  "https://images.unsplash.com/photo-1732278881253-ed69fb34e01e?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxmZWF0dXJlZC1waG90b3MtZmVlZHwyMnx8fGVufDB8fHx8fA%3D%3D"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  // IconButton(
                  //   icon: Icon(Icons.share),
                  //   onPressed: () {},
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.more_vert),
                  //   onPressed: () {},
                  // ),
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
                          Get.bottomSheet(
                              isScrollControlled: true,
                              Form(
                                key: _formKey,
                                child: Wrap(children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                            child: Text(
                                          "Informations personnelles",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        )),
                                        SizedBox(height: 30),
                                        //Champs du formulaire
                                        Text(
                                          "Adresse",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        CustomDropdown<
                                            PositionModel>.searchRequest(
                                          maxlines: 5,
                                          validateOnChange: true,
                                          validator: (p0) {
                                            if (profileRegisterController
                                                .ville.value.isEmpty) {
                                              return "La ville est obligatoire";
                                            }
                                          },
                                          controller: SingleSelectController(
                                              PositionModel(
                                                  displayName: profileRegisterController
                                                              .adresseController
                                                              .value
                                                              .text ==
                                                          ""
                                                      ? "Entrez votre adresse"
                                                      : profileRegisterController
                                                          .adresseController
                                                          .value
                                                          .text)),
                                          searchHintText:
                                              "Entrez votre adresse",
                                          headerBuilder:
                                              (context, selectedItem, enabled) {
                                            return Text(
                                              "${selectedItem.displayName ?? ""}",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            );
                                          },
                                          listItemBuilder: (context, item,
                                              isSelected, onItemSelect) {
                                            return Text(
                                                "${item.displayName ?? ""}");
                                          },
                                          futureRequest: (value) {
                                            return profileRegisterController
                                                .findPositionAddress(value);
                                          },
                                          futureRequestDelay:
                                              Duration(milliseconds: 1500),
                                          hintText: 'Adresse',
                                          noResultFoundText: "Aucune adresse",
                                          decoration: CustomDropdownDecoration(
                                              closedFillColor: !Get.isDarkMode
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                              expandedFillColor: Get.isDarkMode
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                              closedBorder: Border.all(),
                                              closedBorderRadius:
                                                  BorderRadius.circular(4)),
                                          items: profileRegisterController
                                              .positionAddressList,
                                          onChanged: (value) {
                                            profileRegisterController
                                                .updateaddresse(
                                                    value?.displayName ?? "");
                                            profileRegisterController
                                                .updatePosition(
                                                    value ?? PositionModel());
                                          },
                                        ),
                                        SizedBox(height: 15),
                                        Customtextfield(
                                          textController:
                                              profileRegisterController
                                                  .nomController.value,
                                          label: 'Nom',
                                        ),
                                        SizedBox(height: 15),
                                        //Champs prenoms
                                        Customtextfield(
                                          textController:
                                              profileRegisterController
                                                  .prenomController.value,
                                          label: 'Prénoms',
                                        ),
                                        SizedBox(height: 15),
                                        //Champs Secteur
                                        Text(
                                          "Secteur d'activité",
                                          style: TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                        CustomDropdown<SecteurModel>.search(
                                          validateOnChange: true,
                                          validator: (p0) {
                                            if (profileRegisterController
                                                .secteurController
                                                .value
                                                .text
                                                .isEmpty) {
                                              return " Secteur d'activité obligatoire";
                                            }
                                          },
                                          controller: SingleSelectController(
                                              profileRegisterController
                                                  .secteursList.first),
                                          searchHintText: "Secteur d'activité",
                                          headerBuilder:
                                              (context, selectedItem, enabled) {
                                            return Text(
                                              "${selectedItem.libelle ?? ""}",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            );
                                          },
                                          listItemBuilder: (context, item,
                                              isSelected, onItemSelect) {
                                            return Text(
                                                "${item.libelle ?? ""}");
                                          },
                                          hintText: 'Secteur d\'activité',
                                          noResultFoundText:
                                              "Aucun secteur d'activité",
                                          decoration: CustomDropdownDecoration(
                                              closedFillColor: !Get.isDarkMode
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                              expandedFillColor: Get.isDarkMode
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                              closedBorder: Border.all(),
                                              closedBorderRadius:
                                                  BorderRadius.circular(4)),
                                          items: profileRegisterController
                                              .secteursList,
                                          onChanged: (value) {
                                            profileRegisterController
                                                .updateSecteur(
                                                    value?.libelle ?? "");
                                          },
                                        ),
                                        SizedBox(height: 15),
                                        CustomButton(
                                          onPressed: () {
                                            if (_formKey
                                                    .currentState!
                                                    .validate() &&
                                                profileRegisterController
                                                    .prenomController
                                                    .value
                                                    .text
                                                    .isNotEmpty &&
                                                profileRegisterController
                                                    .secteurController
                                                    .value
                                                    .text
                                                    .isNotEmpty &&
                                                profileRegisterController
                                                    .adresseController
                                                    .value
                                                    .text
                                                    .isNotEmpty) {
                                              controller.updateProfile(
                                                  profileRegisterController
                                                      .nomController.value.text,
                                                  profileRegisterController
                                                      .prenomController
                                                      .value
                                                      .text,
                                                  profileRegisterController
                                                      .secteurController
                                                      .value
                                                      .text,
                                                  profileRegisterController
                                                      .adresseController
                                                      .value
                                                      .text,
                                                  profileRegisterController
                                                      .latitude.value,
                                                  profileRegisterController
                                                      .longitude.value);
                                              Get.back();
                                            }
                                          },
                                          enabled: true,
                                          label: "Valider",
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                              ));
                        },
                        child: Wrap(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      "${Env.userAuth.prenom ?? Env.userAuth.pseudo} ${Env.userAuth.nom}",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GoldIcons(
                                      size: 25,
                                      icon: Icons.edit,
                                    )
                                  ],
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  "${Env.userAuth.secteurActivite}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                                    Get.bottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      Form(
                                        key: _formKeyBio,
                                        child: Wrap(children: [
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Biographie",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Customtextfield(
                                                    textController:
                                                        controller.bio.value,
                                                    label: "Bio"),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                CustomButton(
                                                  onPressed: () {
                                                    print(
                                                        "${controller.bio.value.text}");
                                                    controller.updateBio();
                                                    Get.back();
                                                  },
                                                  enabled: true,
                                                  label: "Valider",
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                  child: GoldIcons(
                                    size: 25,
                                    icon: Icons.add,
                                  )))
                        ],
                      ),
                      // Informations de base
                      Visibility(
                        replacement: Text("Aucune descriprtion"),
                        visible: Env.userAuth.biographie == null ? false : true,
                        child: Card(
                          elevation: 0.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(
                                '${Env.userAuth.biographie}',
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
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.bottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.white,
                                  Form(
                                    key: _formKeyExperience,
                                    child: Wrap(children: [
                                      Container(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Ajouter une expérience",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Customtextfield(
                                                textController:
                                                    controller.poste.value,
                                                label: "Poste"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Customtextfield(
                                                textController:
                                                    controller.entreprise.value,
                                                label: "Entrprise"),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            CustomDateField(
                                              controller:
                                                  controller.debut.value,
                                              label: 'Date de début',
                                              hintText: 'Sélectionner une date',
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              onDateSelected: (date) {
                                                print(
                                                    'Date sélectionnée: $date');
                                              },
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            CustomDateField(
                                              isValidator: true,
                                              validator: (value) {
                                                if (value?.isEmpty ?? false) {
                                                  return "Date de fin est obligatoire";
                                                }

                                                try {
                                                  // Création du format de date français
                                                  final DateFormat formatFr =
                                                      DateFormat('dd/MM/yyyy');

                                                  // Parse les dates du format français vers DateTime
                                                  DateTime dateFin =
                                                      formatFr.parse(controller
                                                          .fin.value.text);
                                                  DateTime dateDebut =
                                                      formatFr.parse(controller
                                                          .debut.value.text);

                                                  if (dateFin.isBefore(
                                                          dateDebut) ||
                                                      dateFin.isAtSameMomentAs(
                                                          dateDebut)) {
                                                    return "Date de fin doit être supérieure à la date de début";
                                                  }

                                                  return null;
                                                } catch (e) {
                                                  return "Format de date invalide (JJ/MM/AAAA)";
                                                }
                                              },
                                              controller: controller.fin.value,
                                              label: 'Date de fin',
                                              hintText: 'Sélectionner une date',
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              onDateSelected: (date) {
                                                print(
                                                    'Date sélectionnée: $date');
                                              },
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            CustomButton(
                                              onPressed: () {
                                                if (_formKeyExperience
                                                    .currentState!
                                                    .validate()) {
                                                  print("object");
                                                  controller.updateExperience(
                                                      controller
                                                          .poste.value.text,
                                                      controller.entreprise
                                                          .value.text,
                                                      controller
                                                          .debut.value.text,
                                                      controller
                                                          .debut.value.text);
                                                  Get.back();
                                                }
                                              },
                                              enabled: true,
                                              label: "Valider",
                                            )
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                              child: GoldIcons(
                                size: 25,
                                icon: Icons.add,
                              ),
                            ),
                          )
                        ],
                      ),
                      // Expérience professionnelle
                      Visibility(
                        replacement: Text("Aucune Expérience"),
                        visible: Env.userAuth.experiences?.length == 0
                            ? false
                            : true,
                        child: Card(
                          elevation: 0.0,
                          child: Column(
                            // Ajout d'un Column pour contenir la liste
                            children: List.generate(
                              Env.userAuth.experiences?.length ?? 0,
                              (index) => ExperienceItem(
                                company: Env.userAuth.experiences?[index]
                                        .nomEntreprise ??
                                    "",
                                position:
                                    Env.userAuth.experiences?[index].poste ??
                                        "",
                                period:
                                    "${Env.userAuth.experiences?[index].dateDebut ?? ""} - ${Env.userAuth.experiences?[index].dateFin ?? ""}", // Correction : dateDebut -> dateFin
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
                              height: 20,
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
                                    Get.bottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      Form(
                                        key: _formKeyCompetence,
                                        child: Wrap(children: [
                                          Container(
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Compétences",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                TagTextField(
                                                  onTagsChanged: (tags) {
                                                    controller.update(tags);
                                                    // Faire quelque chose avec les tags
                                                    print(
                                                        'Tags actuels : $tags');
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                CustomButton(
                                                  onPressed: () {
                                                    if (_formKeyCompetence
                                                            .currentState!
                                                            .validate() &&
                                                        Env.skill.isNotEmpty) {
                                                      controller.updateSkill();
                                                      Get.back();
                                                    }
                                                  },
                                                  enabled: true,
                                                  label: "Valider",
                                                )
                                              ],
                                            ),
                                          ),
                                        ]),
                                      ),
                                    );
                                  },
                                  child: Visibility(
                                    visible: true,
                                    child: GoldIcons(
                                      size: 25,
                                      icon: Icons.add,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      // Compétences
                      Visibility(
                        replacement: Text("Aucune compétence"),
                        visible: Env.userAuth.skill == "" ? false : true,
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 100,
                                child: Card(
                                    elevation: 0.0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          Env.userAuth.getCompetence().length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.all(10),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SkillChip(Env.userAuth
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
          );
        },
      )),
    );
  }
}
