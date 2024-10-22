import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/constant.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'Home page',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Pseudo :${box.read("username")}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Email :${box.read("email")}',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
