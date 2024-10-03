import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/interrestprofil_controller.dart';

class InterrestprofilView extends GetView<InterrestprofilController> {
  const InterrestprofilView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InterrestprofilView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'InterrestprofilView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
