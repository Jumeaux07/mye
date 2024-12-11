import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/notification/controllers/notification_controller.dart';

import '../data/auth_provider.dart';
import '../routes/app_pages.dart';

class FirebaseService extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final _notificationController = Get.put(NotificationController());
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;
  FirebaseService._internal();

  Future<void> setupFirebaseMessaging() async {
    // Notification en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu en premier plan');
      // Affichez la notification localement
      showLocalNotification(message);
    });

    // Notification en arrière-plan
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification cliquée');
      // Gérez la navigation ou l'action
      switch (
          message.data['event']?.toString().toUpperCase() ?? "".toUpperCase()) {
        case 'NOTIFY':
          log("Action notify");
          Get.toNamed(Routes.NOTIFICATION);
      }
    });

    //Lorsque firebase met a jour le token
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      box.write("fcm_token", token.toString());
      if (token != "" && box.hasData("token")) {
        _authProvider.updateFcmToken(token);
      }
    });

    // Token de notification
    String? token = await FirebaseMessaging.instance.getToken();

    box.write("fcm_token", token.toString());
    if (token != null && token != "") {
      _authProvider.updateFcmToken(token);
    }

    print('Token Firebase : $token');

    FirebaseMessaging.onMessage.listen((event) async {
      if (event.notification == null) return;
      log("EVENT => ${event.data}");

      switch (
          event.data['event']?.toString().toUpperCase() ?? "".toUpperCase()) {
        case "NOTIFY":
          await _notificationController.getAllNotification();
          refresh();
          log("NOTIFIY EVENT");
          break;
      }
    });
  }

/**
 * Implementation et configuration de notification push local
 */

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@drawable/logoligth");

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }
}
