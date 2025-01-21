import 'dart:developer';

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/conversation_model.dart';
import 'package:nom_du_projet/app/modules/Message/views/message_view.dart';

import '../../../data/get_data.dart';
import '../../../data/models/user_model.dart';

class ConversationController extends GetxController with StateMixin<dynamic> {
  final conversations = <ConversationModel>[].obs;
  final _getData = GetDataProvider();

  Future<void> getConversation() async {
    change(null, status: RxStatus.loading());
    try {
      final response = await _getData.getConversation();
      log("${response.statusCode}");
      if (response.statusCode == 204) {
        change(null, status: RxStatus.error(" ${response.statusText}"));
      } else if (response.statusCode == 200) {
        conversations.value = (response.body['data'] as List)
            .map((e) => ConversationModel.fromJson(e))
            .toList();
        change(conversations, status: RxStatus.success());
      } else {
        change(null,
            status: RxStatus.error(
                "Une erreur s'est produite lors de la récupération des données ${response.statusCode}"));
      }
    } catch (e) {
      change(null,
          status: RxStatus.error(
              "Une erreur s'est produite lors de la récupération des données => $e"));
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
    getConversation();
  }
}
