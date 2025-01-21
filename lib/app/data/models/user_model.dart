import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserModel {
  final int? id;
  final String? nom;
  final String? prenom;
  final String? pseudo;
  final String? secteurActivite;
  final String? adresseGeographique;
  final String? skill;
  final String? biographie;
  final String? phone;
  final String? type;
  final String? entreprise;
  final String? email;
  final double? latitude;
  final double? longitude;
  final dynamic emailVerifiedAt;
  final int? isPremium;
  final String? profileImage;
  final int? isActive;
  final int? isAdmin;
  final String? posteSouhait;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic facturationId;
  final List<Experience>? experiences;

  UserModel({
    this.id,
    this.nom,
    this.prenom,
    this.pseudo,
    this.secteurActivite,
    this.adresseGeographique,
    this.skill,
    this.biographie,
    this.phone,
    this.type,
    this.entreprise,
    this.email,
    this.latitude,
    this.longitude,
    this.emailVerifiedAt,
    this.isPremium,
    this.profileImage,
    this.isActive,
    this.isAdmin,
    this.posteSouhait,
    this.createdAt,
    this.updatedAt,
    this.facturationId,
    this.experiences,
  });

  UserModel copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? pseudo,
    String? secteurActivite,
    String? adresseGeographique,
    String? skill,
    String? biographie,
    String? phone,
    String? type,
    String? entreprise,
    String? email,
    double? latitude,
    double? longitude,
    dynamic emailVerifiedAt,
    int? isPremium,
    String? profileImage,
    int? isActive,
    int? isAdmin,
    String? posteSouhait,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic facturationId,
    List<Experience>? experiences,
  }) =>
      UserModel(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        prenom: prenom ?? this.prenom,
        pseudo: pseudo ?? this.pseudo,
        secteurActivite: secteurActivite ?? this.secteurActivite,
        adresseGeographique: adresseGeographique ?? this.adresseGeographique,
        skill: skill ?? this.skill,
        biographie: biographie ?? this.biographie,
        phone: phone ?? this.phone,
        type: type ?? this.type,
        entreprise: entreprise ?? this.entreprise,
        email: email ?? this.email,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        isPremium: isPremium ?? this.isPremium,
        profileImage: profileImage ?? this.profileImage,
        isActive: isActive ?? this.isActive,
        isAdmin: isAdmin ?? this.isAdmin,
        posteSouhait: posteSouhait ?? this.posteSouhait,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        facturationId: facturationId ?? this.facturationId,
        experiences: experiences ?? this.experiences,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? 0,
        nom: json["nom"] ?? "",
        prenom: json["prenom"],
        pseudo: json["pseudo"],
        secteurActivite: json["secteur_activite"] ?? "Aucun secteur d'activité",
        adresseGeographique: json["adresse_geographique"],
        skill: json["skill"],
        biographie: json["biographie"],
        phone: json["phone"] ?? "",
        type: json["type"],
        entreprise: json["entreprise"],
        email: json["email"] ?? "",
        latitude: json["latitude"] ?? 0.00,
        longitude: json["longitude"] ?? 0.00,
        emailVerifiedAt: json["email_verified_at"],
        isPremium: json["is_premium"],
        profileImage: json["profileImage"],
        isActive: json["is_active"],
        isAdmin: json["is_admin"],
        posteSouhait: json["poste_souhait"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        facturationId: json["facturation_id"],
        experiences: json["experiences"] == null
            ? []
            : List<Experience>.from(
                json["experiences"]!.map((x) => Experience.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "pseudo": pseudo,
        "secteur_activite": secteurActivite,
        "adresse_geographique": adresseGeographique,
        "skill": skill,
        "biographie": biographie,
        "phone": phone,
        "type": type,
        "entreprise": entreprise,
        "email": email,
        "latitude": latitude,
        "longitude": longitude,
        "email_verified_at": emailVerifiedAt,
        "is_premium": isPremium,
        "profileImage": profileImage,
        "is_active": isActive,
        "is_admin": isAdmin,
        "poste_souhait": posteSouhait,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "facturation_id": facturationId,
        "experiences": experiences == null
            ? []
            : List<dynamic>.from(experiences!.map((x) => x.toJson())),
      };

  List<String> getCompetence() {
    List<String> competences;

    if (skill != null) {
      competences = skill.toString().split(',');
    } else {
      competences = [];
    }
    return competences;
  }

  String getFullName() {
    return '$nom $prenom';
  }

  Color getUserTypeColor() {
    switch (type?.toLowerCase()) {
      case 'entreprise':
        return Colors.blue;
      case 'particulier':
        return Colors.green;
      case 'employé':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData getUserTypeIcon() {
    switch (type?.toLowerCase()) {
      case 'entreprise':
        return Icons.business;
      case 'particulier':
        return Icons.person;
      case 'employé':
        return Icons.work;
      default:
        return Icons.person_outline;
    }
  }
}

class Experience {
  final int? id;
  final String? poste;
  final String? nomEntreprise;
  final DateTime? dateDebut;
  final DateTime? dateFin;
  final int? status;
  final int? userId;
  final dynamic createdAt;
  final dynamic updatedAt;

  Experience({
    this.id,
    this.poste,
    this.nomEntreprise,
    this.dateDebut,
    this.dateFin,
    this.status,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Experience copyWith({
    int? id,
    String? poste,
    String? nomEntreprise,
    DateTime? dateDebut,
    DateTime? dateFin,
    int? status,
    int? userId,
    dynamic createdAt,
    dynamic updatedAt,
  }) =>
      Experience(
        id: id ?? this.id,
        poste: poste ?? this.poste,
        nomEntreprise: nomEntreprise ?? this.nomEntreprise,
        dateDebut: dateDebut ?? this.dateDebut,
        dateFin: dateFin ?? this.dateFin,
        status: status ?? this.status,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
        id: json["id"],
        poste: json["poste"],
        nomEntreprise: json["nom_entreprise"],
        dateDebut: json["date_debut"] == null
            ? null
            : DateTime.parse(json["date_debut"]),
        dateFin:
            json["date_fin"] == null ? null : DateTime.parse(json["date_fin"]),
        status: json["status"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poste": poste,
        "nom_entreprise": nomEntreprise,
        "date_debut":
            "${dateDebut!.year.toString().padLeft(4, '0')}-${dateDebut!.month.toString().padLeft(2, '0')}-${dateDebut!.day.toString().padLeft(2, '0')}",
        "date_fin":
            "${dateFin!.year.toString().padLeft(4, '0')}-${dateFin!.month.toString().padLeft(2, '0')}-${dateFin!.day.toString().padLeft(2, '0')}",
        "status": status,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
