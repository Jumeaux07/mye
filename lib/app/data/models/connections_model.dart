import 'package:nom_du_projet/app/data/models/user_model.dart';

class ConnectionsModel {
  final int? id;
  final int? userId;
  final int? connectedUserId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? connectedUser;

  ConnectionsModel({
    this.id,
    this.userId,
    this.connectedUserId,
    this.createdAt,
    this.updatedAt,
    this.connectedUser,
  });

  ConnectionsModel copyWith({
    int? id,
    int? userId,
    int? connectedUserId,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserModel? connectedUser,
  }) =>
      ConnectionsModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        connectedUserId: connectedUserId ?? this.connectedUserId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        connectedUser: connectedUser ?? this.connectedUser,
      );

  factory ConnectionsModel.fromJson(Map<String, dynamic> json) =>
      ConnectionsModel(
        id: json["id"],
        userId: json["user_id"],
        connectedUserId: json["connected_user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        connectedUser: json["connected_user"] == null
            ? null
            : UserModel.fromJson(json["connected_user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "connected_user_id": connectedUserId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "connected_user": connectedUser?.toJson(),
      };
}
