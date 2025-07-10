import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Ajout pour le formatage de la date
import 'package:nom_du_projet/app/data/models/conversation_model.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';
import 'package:nom_du_projet/app/modules/Conversation/controllers/messagee_controller.dart';

class MessageScreen extends StatelessWidget {
  final ConversationModel? conversation;
  final UserModel? user;
  final bool isNewConversation;

  MessageScreen({
    Key? key,
    this.conversation,
    this.user,
    required this.isNewConversation,
  }) : super(key: key);

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Fonction pour formater l'heure
  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      // Aujourd'hui - afficher seulement l'heure
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == today.subtract(Duration(days: 1))) {
      // Hier
      return 'Hier ${DateFormat('HH:mm').format(dateTime)}';
    } else if (now.difference(messageDate).inDays < 7) {
      // Cette semaine - afficher le jour et l'heure
      return DateFormat('E HH:mm', 'fr_FR').format(dateTime);
    } else {
      // Plus ancien - afficher la date et l'heure
      return DateFormat('dd/MM HH:mm').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageController = Get.find<MessageeController>();

    if (conversation != null) {
      messageController.initWithConversation(conversation!);
    }

    return Scaffold(
      appBar: AppBar(
        title: conversation == null
            ? Text("Nouvelle discussion")
            : Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        conversation?.destinataire?.profileImage != null
                            ? NetworkImage(
                                conversation!.destinataire!.profileImage!)
                            : null,
                    child: conversation?.destinataire?.profileImage == null
                        ? Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Text("${conversation?.destinataire?.getFullName()}"),
                ],
              ),
      ),
      body: conversation == null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Aucune conversation trouvée.\nCommence une discussion pour envoyer un message.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      color: Colors.grey[100],
                      child: SafeArea(
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                decoration: InputDecoration(
                                  hintText: "Tape ton message...",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.send, color: Colors.white),
                                onPressed: () {
                                  final content = _controller.text.trim();
                                  if (content.isNotEmpty) {
                                    messageController.sendMessage(content,
                                        receiverId: user?.id);
                                    _controller.clear();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Obx(() => messageController.isLoading.value
                    ? LinearProgressIndicator(minHeight: 2)
                    : SizedBox.shrink()),
                Expanded(
                  child: Obx(() {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController
                          .jumpTo(_scrollController.position.minScrollExtent);
                    });

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messageController.messages.length,
                      reverse: true,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final message = messageController.messages[index];

                        final isMine = message.expediteurId !=
                            conversation?.destinataire?.id;

                        return Align(
                          alignment: isMine
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75),
                            decoration: BoxDecoration(
                              color:
                                  isMine ? Colors.blue[100] : Colors.grey[300],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(isMine ? 12 : 0),
                                bottomRight: Radius.circular(isMine ? 0 : 12),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (message.fichier != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      message.fichier!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (message.contenu != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      message.contenu.toString(),
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        _formatTime(message.createdAt),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      if (isMine) ...[
                                        const SizedBox(width: 4),
                                        Icon(
                                          message.isRead == true
                                              ? Icons.done_all
                                              : Icons.done,
                                          size: 14,
                                          color: message.isRead == true
                                              ? Colors.white70
                                              : Colors.grey[600],
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const Divider(height: 1),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  color: Colors.grey[100],
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Tape ton message...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () {
                              final content = _controller.text.trim();
                              if (content.isNotEmpty) {
                                messageController.sendMessage(content);
                                _controller.clear();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
