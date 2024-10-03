// To parse this JSON data, do
//
//     final secteurModel = secteurModelFromJson(jsonString);

import 'package:animated_custom_dropdown/custom_dropdown.dart';

class SecteurModel with CustomDropdownListFilter {
  int? id;
  String? libelle;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  SecteurModel({
    this.id,
    this.libelle,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  SecteurModel copyWith({
    int? id,
    String? libelle,
    int? status,
    dynamic createdAt,
    dynamic updatedAt,
  }) =>
      SecteurModel(
        id: id ?? this.id,
        libelle: libelle ?? this.libelle,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SecteurModel.fromJson(Map<String, dynamic> json) => SecteurModel(
        id: json["id"],
        libelle: json["libelle"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "libelle": libelle,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };

  @override
  bool filter(String query) {
    // TODO: implement filter
    return libelle.toString().toLowerCase().contains(query);
  }
}
