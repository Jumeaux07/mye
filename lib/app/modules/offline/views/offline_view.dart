import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/offline_controller.dart';

class OfflineView extends GetView<OfflineController> {
  const OfflineView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OfflineView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OfflineView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
