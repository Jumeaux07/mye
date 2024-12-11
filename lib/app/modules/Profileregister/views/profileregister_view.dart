import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/position_model.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';
import '../../../services/image_picker_service.dart';
import '../../../widgets/CustomTextField.dart';
import '../../../widgets/customAppBar.dart';
import '../../../widgets/goldbuttonlight.dart';
import '../../profile_detail/controllers/profile_detail_controller.dart';
import '../controllers/profileregister_controller.dart';

class ProfileregisterView extends GetView<ProfileregisterController> {
  const ProfileregisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final profiledetailController = Get.put(ProfileDetailController());
    final _imagePickerService = ImagePickerService();
    return Scaffold(
      body: SafeArea(
        child: controller.obx(
          (data) => ListView(
            padding: EdgeInsets.all(15),
            children: [
              //AppBar
              Customappbar(
                onTap: () {
                  Get.back();
                },
              ),
              //Avatar
              Obx(() => Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await controller.pickImage();
                        },
                        child: controller.imageEnBase64.value.isEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    profiledetailController
                                            .user.value.profileImage ??
                                        "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996"),
                                radius: 50,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: SizedBox(
                                  width: 110,
                                  height: 110,
                                  child: _imagePickerService.displayBase64Image(
                                      controller.imageEnBase64.value),
                                ),
                              ),
                      ),
                    ],
                  )),
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
                        "Profil",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
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
                      //Champs Adresse
                      Text(
                        "Adresse",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      CustomDropdown<PositionModel>.searchRequest(
                        controller: SingleSelectController(PositionModel(
                            displayName:
                                controller.adresseController.value.text == ""
                                    ? "Entrez votre adresse"
                                    : controller.adresseController.value.text)),
                        searchHintText: "Entrez votre adresse",
                        headerBuilder: (context, selectedItem, enabled) {
                          return Text(
                            "${selectedItem.displayName ?? ""}",
                            style: TextStyle(color: Colors.black),
                          );
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
                            closedFillColor: !Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.white,
                            expandedFillColor: Get.isDarkMode
                                ? Colors.grey[300]
                                : Colors.white,
                            closedBorder: Border.all(),
                            closedBorderRadius: BorderRadius.circular(4)),
                        items: controller.positionAddressList,
                        onChanged: (value) {
                          controller.updateaddresse(value?.displayName ?? "");
                        },
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
                            controller.updateUser(
                                controller.nomController.value.text,
                                controller.prenomController.value.text,
                                controller.secteurController.value.text,
                                controller.adresseController.value.text,
                                controller.bioController.value.text);
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
