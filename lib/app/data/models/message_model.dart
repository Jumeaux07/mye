class MessageModel {
  final int? id;
  final String? contenu;
  final String? fichier;
  final int? isRead;
  final int? expediteurId;
  final int? recepteurId;
  final int? conversationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageModel({
    this.id,
    this.contenu,
    this.fichier,
    this.isRead,
    this.expediteurId,
    this.recepteurId,
    this.conversationId,
    this.createdAt,
    this.updatedAt,
  });

  MessageModel copyWith({
    int? id,
    String? contenu,
    String? fichier,
    int? isRead,
    int? expediteurId,
    int? recepteurId,
    int? conversationId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      MessageModel(
        id: id ?? this.id,
        contenu: contenu ?? this.contenu,
        fichier: fichier ?? this.fichier,
        isRead: isRead ?? this.isRead,
        expediteurId: expediteurId ?? this.expediteurId,
        recepteurId: recepteurId ?? this.recepteurId,
        conversationId: conversationId ?? this.conversationId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json["id"],
        contenu: json["contenu"],
        fichier: json["fichier"],
        isRead: json["is_read"],
        expediteurId: json["expediteur_id"],
        recepteurId: json["recepteur_id"],
        conversationId: json["conversation_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contenu": contenu,
        "fichier": fichier,
        "is_read": isRead,
        "expediteur_id": expediteurId,
        "recepteur_id": recepteurId,
        "conversation_id": conversationId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
