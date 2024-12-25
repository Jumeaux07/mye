// lib/services/chat_service.dart
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../data/constant.dart';
import '../data/models/conversation_model.dart';
import '../widgets/message_classe.dart';

class ChatService{
  static String baseUri = baseUrl;
  
   Future<List<Conversation>> getConversations() async {
    final response = await http.get(
      Uri.parse('$baseUri${getConversation}'),
      headers: {'Authorization': 'Bearer ${box.read("token")}'},
    );
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => Conversation.fromJson(json)).toList();
    }
    throw Exception('Erreur de chargement des conversations');
  }

   Future<List<Message>> getMessages(int conversationId) async {
    final response = await http.get(
      Uri.parse('$baseUrl${getmessageUrl}/$conversationId'),
      headers: {'Authorization': 'Bearer ${box.read("token")}'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((json) =>  Message.fromJson(json))
          .toList();
    }
    throw Exception('Erreur de chargement des messages');
  }

   Future<Message> sendMessage(int conversationId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl${sendMessageUrl}/$conversationId'),
      headers: {
        'Authorization': 'Bearer ${box.read("token")}',
        'Content-Type': 'application/json',
      },
      body: json.encode({'content': content}),
    );
    if (response.statusCode == 201) {
      return Message.fromJson(json.decode(response.body));
    }
    throw Exception('Erreur d\'envoi du message');
  }
}