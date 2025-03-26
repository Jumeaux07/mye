import 'package:nom_du_projet/app/data/constant.dart';
import 'package:nom_du_projet/app/data/models/user_model.dart';

class RelationModel {
  final int? id;
  final int? senderId;
  final int? receiverId;
  final String? message;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? sender;
  final UserModel? receiver;

  RelationModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.sender,
    this.receiver,
  });

  RelationModel copyWith({
    int? id,
    int? senderId,
    int? receiverId,
    String? message,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? sender,
    UserModel? receiver,
  }) =>
      RelationModel(
        id: id ?? this.id,
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        message: message ?? this.message,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        sender: sender ?? this.sender,
        receiver: receiver ?? this.receiver,
      );

  factory RelationModel.fromJson(Map<String, dynamic> json) => RelationModel(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        message: json["message"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        sender:
            json["sender"] == null ? null : UserModel.fromJson(json["sender"]),
        receiver: json["receiver"] == null
            ? null
            : UserModel.fromJson(json["receiver"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "message": message,
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "sender": sender?.toJson(),
        "receiver": receiver?.toJson(),
      };

  UserModel getRelation() {
    if (sender?.id == Env.userAuth.id) {
      return receiver!;
    } else {
      return sender!;
    }
  }
}
