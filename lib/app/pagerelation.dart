import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/modules/relation_request/controllers/relation_request_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/views/relation_request_view.dart';
import 'package:nom_du_projet/app/widgets/connections.dart';

class Pagerelation extends GetView<RelationRequestController> {
  const Pagerelation({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getRequest();
    controller.getRelation();
    return DefaultTabController(
        length: 2, // Nombre de tabs
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.isDarkMode ? Colors.black : Colors.white,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.group_add)),
                Tab(icon: Icon(Icons.group_rounded)),
              ],
            ),
          ),
          body: TabBarView(
            children: [RelationRequestView(), Connections()],
          ),
        ));
  }
}
