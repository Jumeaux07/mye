import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

class MessagerieController extends GetxController {
  // Messages observable
  final messages = <types.Message>[].obs;
  
  // User constant car il ne change pas
  final user = const types.User(id: '1', firstName: 'User');

  @override
  void onInit() {
    super.onInit();
    // Initialiser les messages si nécessaire
    messages.value = []; // Si vous voulez partir avec une liste vide
  }

  void sendMessage(String text) {
    final message = types.TextMessage(
      author: user,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    messages.add(message); // Utiliser add au lieu de insert
  }

  void handleMessageTap(types.Message message) {
    print('Message tapped: ${message.id}');
  }
}
