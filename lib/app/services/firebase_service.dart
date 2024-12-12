import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/modules/notification/controllers/notification_controller.dart';

import '../data/auth_provider.dart';
import '../routes/app_pages.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseService extends GetxController {
  final AuthProvider _authProvider = AuthProvider();
  final _notificationController = Get.put(NotificationController());
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;
  FirebaseService._internal();
  // Afficher une notification immédiate
  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // ID de notification
      message.data['title'],
      message.data['body'],
      platformChannelSpecifics,
    );
  }

  Future<void> setupFirebaseMessaging() async {
    // Notification en premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message reçu en premier plan');
      // Affichez la notification localement
      showNotification(message);
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

    // Token de notification
    String? token = Platform.isAndroid
        ? await FirebaseMessaging.instance.getToken()
        : await FirebaseMessaging.instance.getAPNSToken();

    box.write("fcm_token", token.toString());
    if (token != null && token != "" && box.hasData("token")) {
      _authProvider.updateFcmToken(token);
    }
    print('Token Firebase : ${token}');
    //Lorsque firebase met a jour le token
    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      box.write("fcm_token", token.toString());
      if (token != "" && box.hasData("token")) {
        _authProvider.updateFcmToken(token);
      }
    });

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
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    // Initialisation du service de notifications
    Future<void> init() async {
      // Initialisation des fuseaux horaires
      tz.initializeTimeZones();

      // Configuration pour Android
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Configuration pour iOS/macOS
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
      );

      // Configuration finale
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      // Initialisation du plugin
      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      );
    }

    // Gestion des notifications sur iOS
    void onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) async {
      // Logique personnalisée pour iOS
      print('Notification reçue sur iOS');
    }

    // Gestion de la réponse à une notification
    void onDidReceiveNotificationResponse(
        NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (payload != null) {
        debugPrint('Notification payload: $payload');
      }
    }

    // Afficher une notification immédiate
    Future<void> showNotification(
        {required String title, required String body}) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0, // ID de notification
        title,
        body,
        platformChannelSpecifics,
      );
    }

    // Planifier une notification à une date/heure spécifique
    Future<void> scheduledNotification(
        {required String title,
        required String body,
        required DateTime scheduledDate}) async {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'scheduled channel id',
            'scheduled channel name',
            channelDescription: 'scheduled notification description',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    // Annuler une notification spécifique
    Future<void> cancelNotification(int id) async {
      await flutterLocalNotificationsPlugin.cancel(id);
    }

    // Annuler toutes les notifications
    Future<void> cancelAllNotifications() async {
      await flutterLocalNotificationsPlugin.cancelAll();
    }
  }
}
