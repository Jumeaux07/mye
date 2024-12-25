import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nom_du_projet/app/widgets/message/conversation_title.dart';
import 'package:nom_du_projet/app/widgets/message/newconversationscreen.dart';

import '../../data/models/conversation_model.dart';
import '../../services/chat_service.dart';

class ConversationsScreen extends StatelessWidget {
  @override
final _chatService = ChatService();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<Conversation>>(
        future: _chatService.getConversations(), // Implémentez cette fonction
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement ${snapshot.error.toString()} '));
          }
          final conversations = snapshot.data ?? [];
          
          return ListView.separated(
            itemCount: conversations.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationTile(conversation: conversation);
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Naviguer vers l'écran de nouvelle conversation
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => NewConversationScreen()),
      //     );
      //   },
      //   child: Icon(Icons.message),
      // ),
    );
  }
}