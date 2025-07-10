import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/conversation_model.dart';
import 'package:nom_du_projet/app/data/models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conv_controller.dart';
import 'package:nom_du_projet/app/routes/app_pages.dart';

class MessageeController extends GetxController {
  late ConversationModel conversation;

  var messages = <MessageModel>[].obs;
  var isLoading = true.obs;
  // final conversationcontroller = Get.put(() => ConvController());

  // MessageeController({required this.conversation});

  void initWithConversation(ConversationModel conv) {
    conversation = conv;
    fetchMessages();
  }

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final url = baseUrl + getmessageUrl;
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('${url}${conversation.id}'),
        headers: {'Authorization': 'Bearer ${box.read("token")}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        messages.value = List<MessageModel>.from(
          data.map((m) => MessageModel.fromJson(m)),
        );
      }
    } catch (e) {
      print("Erreur lors du chargement des messages : $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendMessage(String content, {int? receiverId}) async {
    final url = baseUrl + sendMessageUrlUrl;
    try {
      // Déterminer le receiver_id en priorité : paramètre > conversation > user
      int? targetReceiverId;

      if (receiverId != null) {
        // Utiliser le receiverId passé en paramètre
        targetReceiverId = receiverId;
      } else if (conversation != null) {
        // Conversation existante
        targetReceiverId = conversation.receverId;
      } else {
        print("Erreur: Aucun destinataire défini");
        return;
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${box.read("token")}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "reciver_id": targetReceiverId,
          "contenu": content,
        }),
      );
      log("${jsonDecode(response.body)}");
      final conversationJson = jsonDecode(response.body)['conversation'];

      if (response.statusCode == 201) {
        print("info $receiverId");
        final conversationcontroller = Get.find<ConvController>();
        conversationcontroller.fetchConversations();
        await fetchMessages();
        if (receiverId != null) {
          Get.back();
          Get.toNamed(Routes.CONVERSATION);
        }

        // final conversationnew = ConversationModel.fromJson(conversationJson);

        // final messageController = Get.find<MessageeController>();
        // Si c'est bien la conversation en cours, on recharge les messages
      }
    } catch (e) {
      print("Erreur lors de l'envoi du message : $e");
    }
  }
}
