import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/update_pseudo.controller.dart';

class UpdatePseudoScreen extends GetView<UpdatePseudoController> {
  const UpdatePseudoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UpdatePseudoScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UpdatePseudoScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
