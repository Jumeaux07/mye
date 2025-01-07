import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/conversation_model.dart';
import 'chat_screen.dart';

class ConversationTile extends StatelessWidget {
  final ConversationModel conversation;

  const ConversationTile({required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: conversation.image != null
            ? NetworkImage(conversation.image!)
            : null,
        child: conversation.nom != "" ? Text(conversation.nom ?? ""[0]) : null,
      ),
      title: Text(
        conversation.nom ?? "",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              DateFormat.yMMMd().add_Hm().format(
                  conversation.messages?.last.createdAt ?? DateTime.now()),
              style: TextStyle(color: Colors.grey),
            ),
          ),
          if (conversation.messages!
                  .where((e) => e.isRead == 0)
                  .toList()
                  .length >
              0)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                conversation.messages!
                    .where((e) => e.isRead == 0)
                    .toList()
                    .length
                    .toString(),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(conversation: conversation),
          ),
        );
      },
    );
  }
}
