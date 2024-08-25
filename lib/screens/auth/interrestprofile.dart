import 'package:flutter/material.dart';
import 'package:nom_du_projet/screens/widgets/CustomTextField.dart';
import 'package:nom_du_projet/screens/widgets/customAppBar.dart';
import 'package:nom_du_projet/screens/widgets/goldbuttonlight.dart';

class Interrestprofil extends StatefulWidget {
  const Interrestprofil({super.key});

  @override
  State<Interrestprofil> createState() => _InterrestprofilState();
}

class _InterrestprofilState extends State<Interrestprofil> {
  final key = GlobalKey<FormState>();
  final secteurController = TextEditingController();
  final posteController = TextEditingController();
  final competenceController = TextEditingController();
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
                    "Intéressé par",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  Customtextfield(
                      textController: secteurController,
                      label: 'Secteur d\'activité'),
                  SizedBox(
                    height: 15,
                  ),
                  Customtextfield(
                      textController: secteurController, label: 'Compétences'),
                  SizedBox(
                    height: 15,
                  ),
                  //Suivant
                  GoldButtonLight(label: 'Terminer')
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
