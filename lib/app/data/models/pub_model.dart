class PubModel {
  final int? id;
  final String? titre;
  final String? description;
  final String? url;
  final String? urlimage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PubModel({
    this.id,
    this.titre,
    this.description,
    this.url,
    this.urlimage,
    this.createdAt,
    this.updatedAt,
  });

  PubModel copyWith({
    int? id,
    String? titre,
    String? description,
    String? url,
    String? urlimage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      PubModel(
        id: id ?? this.id,
        titre: titre ?? this.titre,
        description: description ?? this.description,
        url: url ?? this.url,
        urlimage: urlimage ?? this.urlimage,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory PubModel.fromJson(Map<String, dynamic> json) => PubModel(
        id: json["id"],
        titre: json["titre"],
        description: json["description"],
        url: json["url"],
        urlimage: json["urlimage"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "titre": titre,
        "description": description,
        "url": url,
        "urlimage": urlimage,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
