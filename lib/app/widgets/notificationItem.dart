import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nom_du_projet/app/data/models/notification_model.dart';
import 'package:nom_du_projet/app/modules/notification/controllers/notification_controller.dart';

import '../data/constant.dart';

class Notificationitem extends StatelessWidget {
  const Notificationitem({super.key, required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());
    return Dismissible(
      key: Key(notification.id.toString()),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        notificationController.deleteNotification(notification.id.toString());
      },
      child: Container(
        color:
            notification.readAt != null ? null : Colors.blue.withOpacity(0.1),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996"),
          ),

          title: Text(
            notification.data?.title ?? "",
            style: TextStyle(
              fontWeight: notification.readAt != null
                  ? FontWeight.normal
                  : FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.data?.message ?? ""),
              SizedBox(height: 4),
              Text(
                formatTimestamp(notification.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          onTap: () {
            notificationController.readNotification(notification.id.toString());
            // TODO: Gérer l'action de la notification
            // if (notification.actionUrl != null) {
            //   // Navigation vers l'URL d'action
            // }
          },
          // ignore: unnecessary_null_comparison
          trailing: notification.readAt == null
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
