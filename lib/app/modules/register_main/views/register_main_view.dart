import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/register/views/register_view.dart';
import 'package:nom_du_projet/app/widgets/custom_steper.dart';

import '../controllers/register_main_controller.dart';

class RegisterMainView extends GetView<RegisterMainController> {
  const RegisterMainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: CustomStepper(views: [RegisterView(), Text("data")])));
  }
}
