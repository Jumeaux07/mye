import 'package:flutter/material.dart';
import 'package:nom_du_projet/app/widgets/gold_icons.dart';

import '../data/constant.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          //Avatar
          CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(
                "https://images.ctfassets.net/h6goo9gw1hh6/2sNZtFAWOdP1lmQ33VwRN3/24e953b920a9cd0ff2e1d587742a2472/1-intro-photo-final.jpg?w=1200&h=992&fl=progressive&q=70&fm=jpg"),
            backgroundColor: Colors.transparent,
          ),

          SizedBox(
            width: 10,
          ),

          //Nom et proffession
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        overflow: TextOverflow.ellipsis,
                        box.read("username") ?? "",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        "Activte",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w100,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 200,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    "Abidjan, Cocody",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w100,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          //Icons de chat
          Expanded(
            child: Container(
              child: GoldIcons(
                size: 40,
                icon: Icons.chat,
              ),
            ),
          )
        ],
      ),
    );
  }
}
