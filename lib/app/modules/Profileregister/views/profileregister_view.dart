import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profileregister_controller.dart';

class ProfileregisterView extends GetView<ProfileregisterController> {
  const ProfileregisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile view'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          '.........',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
