import 'package:flutter/material.dart';

import '../widgets/customAppBar.dart';
import '../widgets/customEmailTextField.dart';
import '../widgets/customPasswordTextField.dart';
import '../widgets/goldbuttonlight.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(15),
        children: [
          Customappbar(),
          SizedBox(
            height: 60,
          ),

          //TextFieldclogin
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title Form
                  Text(
                    "Connexion",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),

                  SizedBox(
                    height: 30,
                  ),
                  //Input Email
                  Customemailtextfield(
                    emailController: email,
                    labal: "Email",
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Inout password
                  Custompasswordtextfield(
                    passwordController: password,
                    label: 'Mot de passe',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),

          //button
          GoldButtonLight(
            label: 'Connexion',
          ),
          SizedBox(
            height: 15,
          ),
          //Forget password
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Mot de passe oublié?',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          )
        ],
      )),
    );
  }
}
