import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nom_du_projet/app/data/models/notification_model.dart';
import 'package:nom_du_projet/app/modules/notification/controllers/notification_controller.dart';
import 'package:nom_du_projet/app/modules/relation_request/controllers/relation_request_controller.dart';

import '../data/constant.dart';
import '../modules/profile_detail/controllers/profile_detail_controller.dart';
import '../routes/app_pages.dart';

class Notificationitem extends StatelessWidget {
  const Notificationitem({super.key, required this.notification});
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    final notificationController = Get.put(NotificationController());
    final profiledetailController = Get.find<ProfileDetailController>();
    final relationController = Get.find<RelationRequestController>();
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
            backgroundImage: NetworkImage(notification.data?.data?.image == null
                ? "https://img.freepik.com/vecteurs-premium/icone-profil-utilisateur-dans-style-plat-illustration-vectorielle-avatar-membre-fond-isole-concept-entreprise-signe-autorisation-humaine_157943-15752.jpg?w=996"
                : "${notification.data?.data?.image}"),
          ),

          title: GestureDetector(
            onTap: () {
              if (notification.data?.data?.event != "NOTIFY") {
                notificationController
                    .readNotification(notification.id.toString());
                profiledetailController.showUserOther(
                    notification.data?.data?.event.toString() ?? "");
              } else {}
              notificationController
                  .readNotification(notification.id.toString());
            },
            child: Text(
              notification.data?.title ?? "",
              style: TextStyle(
                fontWeight: notification.readAt != null
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    if (notification.data?.data?.event != "NOTIFY") {
                      notificationController
                          .readNotification(notification.id.toString());
                      profiledetailController.showUserOther(
                          notification.data?.data?.event.toString() ?? "");
                    } else {}
                    notificationController
                        .readNotification(notification.id.toString());
                  },
                  child: Text(notification.data?.message ?? "")),
              Visibility(
                visible: relationController.requestUser.any((el) =>
                        el.senderId.toString() ==
                            notification.data?.data?.event.toString() &&
                        el.status.toString() == "pending") &&
                    relationController.connectionUsers
                        .where((el) =>
                            el.connectedUserId.toString() ==
                            notification.data?.data?.event.toString())
                        .isEmpty,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        relationController.sendResponseRequest("accepted",
                            "${notification.data?.data?.requestid}");
                      },
                      child: Row(
                        children: [
                          Text("Accepter"),
                          Icon(
                            Icons.check_circle_outline,
                            size: 30,
                            color: Colors.greenAccent,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        relationController.sendResponseRequest("rejected",
                            "${notification.data?.data?.requestid}");
                      },
                      child: Row(
                        children: [
                          Text("Annuler"),
                          Icon(
                            Icons.cancel_outlined,
                            size: 30,
                            color: Colors.redAccent,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
