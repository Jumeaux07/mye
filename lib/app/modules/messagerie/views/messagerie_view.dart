import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import '../controllers/messagerie_controller.dart';

class MessagerieView extends GetView<MessagerieController> {
  const MessagerieView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Obx(() {
        final controller = Get.find<MessagerieController>();
        return Chat(
          messages: controller.messages.value,
          onSendPressed: (types.PartialText message) {
            controller.sendMessage(message.text);
          },
          user: controller.user,
          onMessageTap: (_, message) => controller.handleMessageTap(message),
          theme: DefaultChatTheme(
            primaryColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        );
      }),
    );
  }
}
