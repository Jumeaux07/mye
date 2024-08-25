import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/screens/auth/otp.dart';
import 'package:nom_du_projet/screens/widgets/CustomTextField.dart';
import 'package:nom_du_projet/screens/widgets/customAppBar.dart';
import 'package:nom_du_projet/screens/widgets/customEmailTextField.dart';
import 'package:nom_du_projet/screens/widgets/customPasswordTextField.dart';
import 'package:nom_du_projet/screens/widgets/goldbuttonlight.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final pseudoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          //Appbar
          Customappbar(),
          SizedBox(
            height: 60,
          ),
          //TextField register
          Container(
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Title Form
                    Text(
                      "Identifiants",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    //Pusedo
                    Customtextfield(
                        textController: pseudoController, label: 'Pseudo'),
                    SizedBox(
                      height: 15,
                    ),
                    Customemailtextfield(
                        emailController: emailController, labal: 'Email'),
                    SizedBox(
                      height: 15,
                    ),
                    Custompasswordtextfield(
                        passwordController: passwordController,
                        label: 'Mot de passe'),
                    SizedBox(
                      height: 15,
                    ),
                    Custompasswordtextfield(
                        validator: (value) {
                          if (passwordController.text != value) {
                            return "Les mots de passe ne correspondent pas";
                          }
                          return null;
                        },
                        passwordController: passwordConfirmationController,
                        label: 'Confirmation'),

                    SizedBox(
                      height: 15,
                    ),
                    GoldButtonLight(
                      label: "S'inscrire",
                      onTap: () => Get.to(() => Otp()),
                    ),
                  ],
                )),
          ),
        ],
      )),
    );
  }
}
