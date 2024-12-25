import 'package:firebase_auth/firebase_auth.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';

class Conversation {
  final int id;
  final UserModel otherUser;
  final DateTime lastMessageAt;
  final int unreadCount;

  Conversation({
    required this.id,
    required this.otherUser,
    required this.lastMessageAt,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      otherUser: UserModel.fromJson(json['other_user']),
      lastMessageAt: DateTime.parse(json['last_message_at']),
      unreadCount: json['unread_count'],
    );
  }
}