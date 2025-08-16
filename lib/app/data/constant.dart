import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conversation_controller.dart';
import 'package:nom_du_projet/app/services/permission_service.dart';
import 'package:nom_du_projet/contectivity_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';
import 'dart:ui' as ui;

import '../widgets/custom_marcker.dart';

const baseUrl = "https://api-mye.cefir.tech/api";
const registerUrl = "/user/register/step1";
const verifyOtpCodeUrl = "/user/otp_verify";
const getAbonnementUrl = "/get-all-facturation";
const getAllUserUrl = "/get-all-profile";
const showUserUrl = "/show-profile/";
const updateProfillUrl = "/update-profile";
const loginUrl = "/login";
const getUserUrl = "/me";
const startconversationUrl = "/startConversation";
const updatePswdUrl = "/update-password";
const ressetpasswordUrl = "/ressetpassword";
const verifyOTPdUrl = "/verifyOTP";
const resetPasswordUrl = "/resetPassword";
const sendMessageUrlUrl = "/send-message";
const sendFileUrl = "/send-file";
const saveSecteurUrl = "/save-secteur";
const sendRequestUrl = "/connections/request";
const deleteConnectionUrl = "/connections/requests/delete";
const sendResponseRequestUrl = "/connections/request/";
const getRequestUrl = "/connections/requests/pending";
const getRequesSendtUrl = "/connections/requests/sent";
const getRelationUrl = "/connections";
const updateSkilUrl = "/update-skill";
const updatecentreInteretUrl = "/update-centre-interet";
const updateImageUrl = "/update-imageprofile";
const updateBioUrl = "/update-bio";
const getConversationUrl = "/get-conversation";
const getmessageUrl = "/get-message/";
const updateExperienceUrl = "/update-experience";
const sendMessageUrl = "send-message";
const updateFcmTokenUrl = "/update-fcm-token";
const getAllNotificationUrl = "/notifications";
const readNotificationUrl = "/notifications-read/";
const readAllNotificationUrl = "/notifications-read-all";
const deleteNotificationUrl = "/delete-notification/";
const deleteAllNotificationUrl = "/delete-all-notification/";
const updatePremium = "/update-ispremium";
const getfacturelist = "/get-factures-liste";

const getSecteurUrl = "/get-all-secteurs";
const getPubUrl = "/get-pub";
const searchUrl = "/search";

const focusedBorderColor = Color(0xFFCBA948);
const yellowColor = Color(0xFFCBA948);
const fillColor = Color.fromRGBO(243, 246, 249, 0);
const borderColor = Color(0xFFCBA948);
const orColor = Color(0xFFCBA948);

GetStorage box = GetStorage();

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(
    fontSize: 22,
    color: Color.fromRGBO(30, 60, 87, 1),
  ),
  decoration: BoxDecoration(
    border: Border.all(color: borderColor),
  ),
);

final permissionService = PermissionService();

String convertDate(String? dateEn) {
  DateTime date = DateTime.parse(dateEn ?? "");
  String formattedDate = DateFormat.yMMMMEEEEd('fr_FR').format(date);
  return formattedDate;
}

// Pour convertir "02/01/2025" en "2025-01-02"
String? convertToLaravelDate(String? frenchDate) {
  if (frenchDate == null || frenchDate.isEmpty) {
    return null;
  }

  try {
    final DateFormat formatFr = DateFormat('dd/MM/yyyy');
    final DateFormat formatLaravel =
        DateFormat('yyyy-MM-dd HH:mm:ss'); // Format complet pour Laravel/Carbon

    DateTime date = formatFr.parse(frenchDate);
    return formatLaravel.format(date);
  } catch (e) {
    print("Erreur de conversion de date: $e");
    return null;
  }
}

String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inMinutes < 60) {
    return 'Il y a ${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    return 'Il y a ${difference.inHours}h';
  } else if (difference.inDays < 7) {
    return 'Il y a ${difference.inDays}j';
  } else {
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }
}

class Env {
  static UserModel userAuth = UserModel();
  static UserModel userOther = UserModel();
  static String usertoken = "";
  static List<String> skill = [];
  static List<String> contreIntert = [];
  static String mapsToken = "pk.22cea6c61d7cd26bad1424434572ed85";
  static String API_KEY = "91988269679b43217f5bb6.89080309";
  static String SITE_ID = "105886764";
  // static String API_KEY = "1126326932679b448298c262.74340501";
  // static String SITE_ID = "105886764";
  static String PUBLISHABLEKEY =
      "pk_test_51Nae9OCTPwtZUmrOoAgs4oIBecNZIAYQUkiMt25puI0o8auPaDAgQ2rY93HxFxLzCXdqksnisdye3xXzz2lZZZAH00GK0MIV2j";
  static String STRIPEKEY =
      "sk_test_51Nae9OCTPwtZUmrOCTHr2SHw8ydiYwxU6nURgqRJalX1eWf1A471d9qFRy3zotnvSXCmdow4IpwFXKF5fIMmD7U300B51fuqou";
  static String NOTIFY_URL = "";
  static int notificationnCount = 0;
  static int connectionCount = 0;
}

final conversationController = Get.find<ConversationController>();

final dateFormatter = DateFormat('yyyy-MM-dd');

final contectivityController = Get.find<ContectivityController>();

String genererChaineUnique([int longueur = 15]) {
  const caracteres =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  Random random = Random();

  return List.generate(
      longueur, (_) => caracteres[random.nextInt(caracteres.length)]).join();
}

Future<String> getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  box.write("version", version);
  return version;
}
