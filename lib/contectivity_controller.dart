import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';

class ContectivityController extends GetxController {
  final customChecker = InternetConnectionChecker.createInstance();
  final isConnected = false.obs;

  Future<bool> checkInternet() async {
    final customChecker = InternetConnectionChecker.createInstance(
      addresses: [
        AddressCheckOption(
            uri: Uri.parse('https://api.github.com/users/octocat')),
        AddressCheckOption(
          uri: Uri.parse('https://api.agify.io/?name=michael'),
        ),
      ],
      slowConnectionConfig: SlowConnectionConfig(
        enableToCheckForSlowConnection: true,
        slowConnectionThreshold: const Duration(seconds: 1),
      ),
    );

    isConnected.value = await customChecker.hasConnection;
    print('Custom instance connected: $isConnected');

    return isConnected.value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    customChecker.dispose();
  }
}
