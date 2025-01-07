// message_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/get_data.dart';
import 'package:nom_du_projet/app/data/models/message_model.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/conversation_controller.dart';

class MessageController extends GetxController with StateMixin<dynamic> {
  final messageController = TextEditingController().obs;
  final scrollController = ScrollController().obs;
  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  final _getData = GetDataProvider();
  final _conversationController = Get.find<ConversationController>();

  void getMessages(String conversationId) async {
    isLoading.value = true;
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.getMessage(conversationId);
      if (response.statusCode == 200) {
        messages.value = (response.body['data'] as List)
            .map((e) => MessageModel.fromJson(e))
            .toList();
        isLoading.value = false;
        change(messages, status: RxStatus.success());
      }
      if (response.statusCode == 404) {
        isLoading.value = false;
        change(null, status: RxStatus.success());
      }
      if (response.statusCode != 200) {
        isLoading.value = false;
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de la récupération des données ${response.statusCode}"));
      }
    } catch (e) {
      isLoading.value = false;
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de la récupération des données => $e"));
    }
  }

  void sendMessage(String? conversationId, String receiverId) async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.sendMessage(
        receiverId,
        messageController.value.text,
        conversationId,
      );
      if (response.statusCode == 201) {
        messageController.value.clear();

        messages.insert(0, MessageModel.fromJson(response.body['data']));
        _conversationController.getConversation();
        change(messages, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de l'envoi du message ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de l'envoi du message => $e"));
    }
  }

  void sendFile(String? conversationId, String receiverId, File file) async {
    log('$conversationId $receiverId $file');
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.sendFile(
        receiverId,
        file,
        conversation_id: conversationId,
      );
      log(response.body['data'].toString());

      if (response.statusCode == 201) {
        messages.insert(0, MessageModel.fromJson(response.body['data']));
        _conversationController.getConversation();
        change(messages, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de l'envoi du fichier ${response.body['message']} ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de l'envoi du fichier => $e"));
    }
  }

  void updateMessagePreview(String messageId, types.PreviewData previewData) {
    final index =
        messages.indexWhere((element) => element.id.toString() == messageId);
    if (index != -1) {
      // Mettez à jour le message dans votre liste en fonction de votre modèle MessageModel
      update();
    }
  }
}
