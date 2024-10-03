import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/position_model.dart';
import 'package:nom_du_projet/app/data/models/secteur_model.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/customAppBar.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../controllers/profileregister_controller.dart';

class ProfileregisterView extends GetView<ProfileregisterController> {
  const ProfileregisterView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getSecteur();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: controller.obx(
          (data) => ListView(
            padding: EdgeInsets.all(15),
            children: [
              //AppBar
              Customappbar(),
              //Avatar
              Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg"),
                    radius: 50,
                  ),
                  Positioned(
                    child: Icon(
                      Icons.edit,
                      size: 40,
                      color: Color(0xFFCBA948),
                    ),
                    bottom: 1,
                    right: 130,
                  ),
                ],
              ),
              SizedBox(height: 30),
              //Formulaire
              Container(
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Titre
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 30),
                      //Champs du formulaire
                      Customtextfield(
                        textController: controller.nomController.value,
                        label: 'Nom',
                      ),
                      SizedBox(height: 15),
                      //Champs prenoms
                      Customtextfield(
                        textController: controller.prenomController.value,
                        label: 'Prénoms',
                      ),
                      SizedBox(height: 15),
                      //Champs ville
                      Text(
                        "Ville",
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w100,
                            color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      CustomDropdown<PositionModel>.searchRequest(
                        searchHintText: "Entrez votre la ville",
                        headerBuilder: (context, selectedItem, enabled) {
                          return Text("${selectedItem.address?.name ?? ""}");
                        },
                        listItemBuilder:
                            (context, item, isSelected, onItemSelect) {
                          return Text("${item.address?.name ?? ""}");
                        },
                        futureRequest: (value) {
                          return controller.findPositionAddress(value);
                        },
                        futureRequestDelay: Duration(milliseconds: 1500),
                        hintText: 'Ville',
                        noResultFoundText: "Aucune ville",
                        decoration: CustomDropdownDecoration(
                            closedBorder: Border.all(),
                            closedBorderRadius: BorderRadius.circular(4)),
                        items: controller.positionAddressList,
                        controller: SingleSelectController(PositionModel(
                            address: Address(
                                name: controller.villeController.value.text))),
                        onChanged: (value) {
                          controller.updateVille(value?.address?.name ?? "");
                        },
                      ),
                      SizedBox(height: 15),
                      //Champs Adresse
                      Text(
                        "Adresse",
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w100,
                            color: Colors.black),
                      ),
                      CustomDropdown<PositionModel>.searchRequest(
                        controller: SingleSelectController(PositionModel(
                            displayName:
                                controller.adresseController.value.text)),
                        searchHintText: "Entrez votre adresse",
                        headerBuilder: (context, selectedItem, enabled) {
                          return Text("${selectedItem.displayName ?? ""}");
                        },
                        listItemBuilder:
                            (context, item, isSelected, onItemSelect) {
                          return Text("${item.displayName ?? ""}");
                        },
                        futureRequest: (value) {
                          return controller.findPositionAddress(value);
                        },
                        futureRequestDelay: Duration(milliseconds: 1500),
                        hintText: 'Adresse',
                        noResultFoundText: "Aucune adresse",
                        decoration: CustomDropdownDecoration(
                            closedBorder: Border.all(),
                            closedBorderRadius: BorderRadius.circular(4)),
                        items: controller.positionAddressList,
                        onChanged: (value) {
                          controller.updateaddresse(value?.displayName ?? "");
                        },
                      ),
                      SizedBox(height: 15),
                      // Secteur d'activité récupéré depuis les données
                      Text(
                        "Secteur d'activité",
                        style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w100,
                            color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      CustomDropdown.search(
                          noResultFoundText: "Aucun ecteurs d'activité",
                          decoration: CustomDropdownDecoration(
                              closedBorder: Border.all(),
                              closedBorderRadius: BorderRadius.circular(4)),
                          hintText: "Selectionner une spécialité",
                          items: controller.secteursList,
                          listItemBuilder:
                              (context, item, isSelected, onItemSelect) {
                            return Text(item.libelle ?? "");
                          },
                          headerBuilder: (context, selectedItem, enabled) {
                            return Text(
                              selectedItem.libelle ?? "",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black),
                            );
                          },
                          onChanged: (value) {
                            print("${controller.secteurController.value.text}");
                            controller.updateSecteur(value?.libelle ?? "");
                          }),

                      SizedBox(height: 15),
                      Customtextfield(
                        textController: controller.competenceController.value,
                        label: 'Compétences',
                      ),
                      SizedBox(height: 15),
                      Customtextfield(
                        textController: controller.bioController.value,
                        label: 'Bio',
                      ),
                      SizedBox(height: 15),
                      //Bouton Suivant
                      GoldButtonLight(
                          isLoading: false,
                          label: 'Suivant',
                          onTap: () {
                            Get.dialog(CustomAlertDialog(
                                message:
                                    "Fontionnalité en cours de devéloppement...",
                                onPressed: () {
                                  Get.back();
                                },
                                showAlertIcon: true));
                            // Get.toNamed(Routes.INTERRESTPROFIL);
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          onLoading: Center(child: CircularProgressIndicator()),
          onError: (error) {
            return CustomAlertDialog(
                message: "$error",
                onPressed: () {
                  controller.getSecteur();
                },
                showAlertIcon: true);
          },
        ),
      ),
    );
  }
}
