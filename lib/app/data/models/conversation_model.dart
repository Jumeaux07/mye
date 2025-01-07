// To parse this JSON data, do
//
//     final conversationModel = conversationModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:nom_du_projet/app/data/models/message_model.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';

class ConversationModel {
  final int? receverId;
  final int? id;
  final String? nom;
  final String? image;
  final RxString lastmessage;
  final int? isRead;
  final DateTime? createdAt;
  final DateTime updatedAt;
  final int? laravelThroughKey;
  final List<MessageModel>? messages;
  final UserModel? destinataire;
  ConversationModel({
    this.id,
    this.receverId,
    this.nom,
    this.image,
    required String lastmessage,
    this.destinataire,
    this.isRead,
    this.createdAt,
    required this.updatedAt,
    this.laravelThroughKey,
    this.messages,
  }) : lastmessage = RxString(lastmessage);
  ConversationModel copyWith(
          {int? id,
          int? receverId,
          String? nom,
          String? image,
          String? lastmessage,
          UserModel? destinataire,
          int? isRead,
          DateTime? createdAt,
          DateTime? updatedAt,
          int? laravelThroughKey,
          List<MessageModel>? messages}) =>
      ConversationModel(
        id: id ?? this.id,
        receverId: receverId ?? this.receverId,
        nom: nom ?? this.nom,
        image: image ?? this.image,
        lastmessage: lastmessage ?? this.lastmessage.value,
        destinataire: destinataire ?? this.destinataire,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        laravelThroughKey: laravelThroughKey ?? this.laravelThroughKey,
        messages: messages ?? this.messages,
      );
  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      ConversationModel(
        id: json["id"],
        receverId: json["reciver_id"],
        nom: json["nom"],
        image: json["image"],
        lastmessage: json["lastmessage"],
        destinataire: json["destinataire"] == null
            ? null
            : UserModel.fromJson(json["destinataire"]),
        isRead: json["is_read"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        laravelThroughKey: json["laravel_through_key"],
        messages: json["messages"] == null
            ? []
            : List<MessageModel>.from(
                json["messages"].map((x) => MessageModel.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "reciver_id": receverId,
        "nom": nom,
        "image": image,
        "lastmessage": lastmessage.value,
        "destinataire": destinataire?.toJson(),
        "is_read": isRead,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "laravel_through_key": laravelThroughKey,
        "messages": messages,
      };
}
