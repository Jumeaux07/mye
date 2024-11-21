import 'package:flutter/material.dart';
import 'package:nom_du_projet/app/widgets/CustomTextField.dart';

import 'profile_card.dart';

class Accueil extends StatelessWidget {
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
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            children: [
              ProfileCard(),
              SizedBox(
                height: 10,
              ),
              ProfileCard(),
              SizedBox(
                height: 10,
              ),
              ProfileCard(),
              SizedBox(
                height: 10,
              ),
              ProfileCard(),
            ],
          ),
        ],
      ),
    );
  }
}
