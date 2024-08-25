import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/screens/auth/interrestprofile.dart';
import 'package:nom_du_projet/screens/widgets/CustomTextField.dart';
import 'package:nom_du_projet/screens/widgets/customAppBar.dart';
import 'package:nom_du_projet/screens/widgets/goldbuttonlight.dart';

class Profileregister extends StatefulWidget {
  const Profileregister({super.key});

  @override
  State<Profileregister> createState() => _ProfileregisterState();
}

class _ProfileregisterState extends State<Profileregister> {
  final key = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final villeController = TextEditingController();
  final adresseController = TextEditingController();
  final secteurController = TextEditingController();
  final posteController = TextEditingController();
  final competenceController = TextEditingController();
  final bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
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
          SizedBox(
            height: 30,
          ),
          //Form
          Container(
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title Form
                  Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //Nom
                  Customtextfield(textController: nomController, label: 'Nom'),
                  SizedBox(
                    height: 15,
                  ),
                  Customtextfield(
                      textController: prenomController, label: 'Prénoms'),
                  SizedBox(
                    height: 15,
                  ),
                  Customtextfield(
                      textController: villeController, label: 'Ville'),
                  SizedBox(
                    height: 15,
                  ),
                  Customtextfield(
                      textController: adresseController, label: 'Adresse'),
                  SizedBox(
                    height: 15,
                  ),
                  Customtextfield(
                      textController: secteurController,
                      label: 'Secteur  d\'activité'),
                  SizedBox(
                    height: 15,
                  ),
                  Customtextfield(
                      textController: secteurController, label: 'Compétences'),
                  SizedBox(
                    height: 15,
                  ),
                  Customtextfield(textController: bioController, label: 'Bio'),
                  SizedBox(
                    height: 15,
                  ),
                  //Suivant
                  GoldButtonLight(
                    label: 'Suivant',
                    onTap: () => Get.to(() => Interrestprofil()),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
