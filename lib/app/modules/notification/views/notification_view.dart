import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/widgets/custom_alert.dart';
import '../../../widgets/notificationItem.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});
  @override
  Widget build(BuildContext context) {
     controller.getAllNotification();
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.done_all),
            onPressed: () {
              controller.readAllNotification();
            },
            tooltip: 'Tout marquer comme lu',
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'settings':
                  // TODO: Navigation vers les paramètres de notification
                  break;
                case 'clear':
                  controller.deleteAllNotification();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'clear',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Tout effacer'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: controller.obx(
          (data) =>controller.listNotification.length == 0?   Center(
            child: Text(
                    'Aucune notification',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500
                    ),
                  ),
          ):  RefreshIndicator(
                onRefresh: () async {
                  // TODO: Rafraîchir les notifications
                  await Future.delayed(Duration(seconds: 1));
                  controller.getAllNotification();
                },
                child:  ListView.builder(
                  itemCount: controller.listNotification.length,
                  itemBuilder: (context, index) {
                    return Notificationitem(
                      notification: controller.listNotification[index],
                    );
                  },
                ),
              ),
             onLoading: Center(child: CircularProgressIndicator(),),
          onEmpty: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'Aucune notification',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
