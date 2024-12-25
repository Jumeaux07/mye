import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/position_model.dart';
import 'package:nom_du_projet/app/data/models/secteur_model.dart';
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
    return Obx(() => Scaffold(
          body: SafeArea(
            child:Center(
              child: ListView(
                  padding: EdgeInsets.all(15),
                  children: [
                    //AppBar
                    Customappbar(
                      onTap: () {
                        Get.back();
                      },
                    ),
                    //Avatar
                  Stack(
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
                                    
                        //Bouton Suivant
                        GoldButtonLight(
                            isLoading: false,
                            label: 'Suivant',
                            onTap: () {
                              profiledetailController.updateImageProfile(controller.imageEnBase64.value);
                            })
                           
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ),
          
        ),
      )
    );
  }
}
