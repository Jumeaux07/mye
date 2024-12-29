import 'package:flutter/material.dart';
import 'package:nom_du_projet/app/widgets/gold_icons.dart';
import 'package:transparent_image/transparent_image.dart';

import '../data/constant.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    this.image,
    this.username,
    this.secteur,
    this.adresse,
    // required user,
  });

  final String? image;
  final String? username;
  final String? secteur;
  final String? adresse;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
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
            radius: 25.0,
            child: ClipOval(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: image ??
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Outdoors-man-portrait_%28cropped%29.jpg/440px-Outdoors-man-portrait_%28cropped%29.jpg",
                width: 50.0, // Double du radius
                height: 50.0,
                fit: BoxFit.cover,
              ),
            ),
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
                        username ?? "",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Text(
                        overflow: TextOverflow.ellipsis,
                        secteur ?? "",
                        style: TextStyle(
                            fontSize: 15,
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
                    adresse ?? "",
                    style: TextStyle(
                        fontSize: 15,
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
                size: 20,
                icon: Icons.chat,
              ),
            ),
          )
        ],
      ),
    );
  }
}
