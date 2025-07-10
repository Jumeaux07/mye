import 'dart:convert';
import 'dart:developer';

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/conversation_model.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/messagee_controller.dart';
import 'package:nom_du_projet/app/modules/Conversation/views/messageScree.dart';
import 'package:nom_du_projet/app/modules/Message/views/message_view.dart';
import 'package:http/http.dart' as http;

import '../../../data/get_data.dart';
import '../../../data/models/user_model.dart';

class ConversationController extends GetxController with StateMixin<dynamic> {
  final conversations = <ConversationModel>[].obs;
  final _getData = GetDataProvider();
  final messageController = Get.put(MessageeController());

  void resetData() {
    conversations.value = [];
  }

  Future<void> hasConversation(UserModel user) async {
    final url = Uri.parse("$baseUrl/getconversation?reciver_id=${user.id}");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer ${box.read("token")}"
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('Données reçues: $data');

        if (data['data'] == 0) {
          // Aucune conversation existante, on en crée une au moment de l'envoi du 1er message
          Get.to(() => MessageScreen(
                user: user, // envoie juste le destinataire
                isNewConversation: true,
              ));
        } else {
          final conversation = ConversationModel.fromJson(data['data']);
          log("Conversation ${conversation}");

          messageController.initWithConversation(conversation!);
          Get.to(() => MessageScreen(
                conversation: conversation,
                isNewConversation: false,
              ));
        }
      } else {
        print('Erreur HTTP: ${response.body}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
    }
  }

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> getConversation() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _getData.getConversation();
      log("${response.statusCode}");

      if (response.statusCode == 204) {
        errorMessage.value = response.statusText ?? "Pas de contenu";
      } else if (response.statusCode == 200) {
        final data = response.body['data'] as List;
        conversations.value =
            data.map((e) => ConversationModel.fromJson(e)).toList();

        if (conversations.isNotEmpty) {
          box.write('conversation', 'ok');
        }
      } else {
        errorMessage.value =
            "Erreur lors de la récupération : ${response.statusCode}";
      }
    } catch (e) {
      errorMessage.value = "Erreur : $e";
    } finally {
      isLoading.value = false;
    }
  }

  void openDiscussion(ConversationModel discussion) {
    Get.to(
      () => const MessageView(),
      arguments: {
        'conversationId': discussion.id.toString(),
        'receiverId': discussion.destinataire?.id.toString(),
        'receiverName': discussion.destinataire?.getFullName(),
        'receiverPhoto': discussion.destinataire?.profileImage,
        'currentUserId':
            Env.userAuth.id, // Ajoutez l'ID de l'utilisateur connecté1
      },
    );
  }

  void openNewDiscussion(UserModel user) {
    Get.to(
      () => const MessageView(),
      arguments: {
        'conversationId': null,
        'receiverId': user.id.toString(),
        'receiverName': user.getFullName(),
        'receiverPhoto': user.profileImage,
        'currentUserId':
            Env.userAuth.id, // Ajoutez l'ID de l'utilisateur connecté
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    if (box.hasData("token")) {
      getConversation();
    }
  }
}
