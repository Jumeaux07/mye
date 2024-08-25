import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/screens/auth/login.dart';
import 'package:nom_du_projet/screens/auth/register.dart';
import 'package:nom_du_projet/screens/widgets/bouttongoogle.dart';
import 'package:nom_du_projet/screens/widgets/intro.dart';
import 'package:nom_du_projet/screens/widgets/intro3.dart';
import '../widgets/goldbuttonlight.dart';
import '../widgets/intro2.dart';

class MainIntro extends StatefulWidget {
  const MainIntro({super.key});

  @override
  State<MainIntro> createState() => _MainIntroState();
}

final pageController = PageController(initialPage: 0);
var pageactivePage = 0;

final List<Widget> introPages = [
  Intro(),
  Intro2(),
  Intro3(),
];
Timer? timer;

class _MainIntroState extends State<MainIntro> {
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (pageactivePage < introPages.length) {
        pageactivePage++;
      } else {
        pageactivePage = 0;
      }

      pageController.animateToPage(
        pageactivePage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Logo
              Image.asset(
                "assets/images/LOGO-MYE-Ligth.png",
                width: Get.width * 0.45,
              ),
              // Image View Introduction
              Container(
                height: Get.height * 0.30,
                child: PageView.builder(
                    onPageChanged: (int page) {
                      setState(() {
                        pageactivePage = page;
                      });
                      if (page > introPages.length - 1) print("OKOK");
                    },
                    controller: pageController,
                    itemCount: introPages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return introPages[index % introPages.length];
                    }),
              ),
              // Boutton activate
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centrer les indicateurs
                children: List<Widget>.generate(introPages.length, (index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        pageController.animateToPage(index,
                            duration: Duration(seconds: 3),
                            curve: Curves.linear);
                      },
                      child: CircleAvatar(
                        radius: 5, // Ajuster la taille de l'indicateur
                        backgroundColor: index == pageactivePage
                            ? Color(0xFFCBA948)
                            : Colors
                                .grey, // Modifier la couleur pour plus de clarté
                      ),
                    ),
                  );
                }),
              ),
              // Button connexion
              Column(
                children: [
                  GoldButtonLight(
                    label: 'Connexion',
                    onTap: () => Get.to(() => Login()),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GoldButtonGoogle(),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () => Get.to(() => Register()),
                    child: Text(
                      "S'inscrire",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
