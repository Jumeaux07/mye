import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/home/controllers/home_controller.dart';
import 'package:nom_du_projet/app/widgets/CustomTextField.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';

import 'profile_card.dart';

class Accueil extends GetView<HomeController> {
  const Accueil({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Customtextfield(
              textController: searchController,
              label: '',
              hintText: "Rechercher des contacts, entreprises...",
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              children: [
                Text(
                  "SuggestionS",
                  style: TextStyle(fontSize: 17),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.black,
                    height: 5.0,
                    thickness: 2.0,
                    indent: 10.0,
                  ),
                ),
              ],
            ),
          ),
          controller.obx(
            (data) => ListView.builder(
              itemCount: controller.userList.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              itemBuilder: (BuildContext context, int index) {
                return ProfileCard(
                  image: controller.userList[index].profileImage,
                  secteur: controller.userList[index].secteurActivite,
                  username: controller.userList[index].pseudo,
                  adresse: controller.userList[index].adresseGeographique,
                );
              },
            ),
            onLoading: Center(child: CircularProgressIndicator()),
            onError: (error) {
              return CustomAlertDialog(
                  message: "$error",
                  onPressed: () {
                    controller.getAllUser();
                  },
                  showAlertIcon: true);
            },
          ),
        ],
      ),
    );
  }
}
