import 'dart:convert';

class UserModel {
  int? id;
  String? nom;
  String? prenom;
  String? pseudo;
  String? secteurActivite;
  String? adresseGeographique;
  String? competence;
  String? biographie;
  String? phone;
  String? email;
  dynamic emailVerifiedAt;
  int? isPremium;
  String? profileImage;
  int? isActive;
  int? isAdmin;
  String? posteSouhait;
  String? apiToken;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.nom,
    this.prenom,
    this.pseudo,
    this.secteurActivite,
    this.adresseGeographique,
    this.competence,
    this.biographie,
    this.phone,
    this.email,
    this.emailVerifiedAt,
    this.isPremium,
    this.profileImage,
    this.isActive,
    this.isAdmin,
    this.posteSouhait,
    this.apiToken,
    this.createdAt,
    this.updatedAt,
  });

  UserModel copyWith({
    int? id,
    String? nom,
    String? prenom,
    String? pseudo,
    String? secteurActivite,
    String? adresseGeographique,
    String? competence,
    String? biographie,
    String? phone,
    String? email,
    dynamic emailVerifiedAt,
    int? isPremium,
    String? profileImage,
    int? isActive,
    int? isAdmin,
    String? posteSouhait,
    String? apiToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserModel(
        id: id ?? this.id,
        nom: nom ?? this.nom,
        prenom: prenom ?? this.prenom,
        pseudo: pseudo ?? this.pseudo,
        secteurActivite: secteurActivite ?? this.secteurActivite,
        adresseGeographique: adresseGeographique ?? this.adresseGeographique,
        competence: competence ?? this.competence,
        biographie: biographie ?? this.biographie,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        isPremium: isPremium ?? this.isPremium,
        profileImage: profileImage ?? this.profileImage,
        isActive: isActive ?? this.isActive,
        isAdmin: isAdmin ?? this.isAdmin,
        posteSouhait: posteSouhait ?? this.posteSouhait,
        apiToken: apiToken ?? this.apiToken,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nom: json["nom"],
        prenom: json["prenom"],
        pseudo: json["pseudo"],
        secteurActivite: json["secteur_activite"],
        adresseGeographique: json["adresse_geographique"],
        competence: json["competence"],
        biographie: json["biographie"],
        phone: json["phone"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        isPremium: json["is_premium"],
        profileImage: json["profileImage"],
        isActive: json["is_active"],
        isAdmin: json["is_admin"],
        posteSouhait: json["poste_souhait"],
        apiToken: json["api_token"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "pseudo": pseudo,
        "secteur_activite": secteurActivite,
        "adresse_geographique": adresseGeographique,
        "competence": competence,
        "biographie": biographie,
        "phone": phone,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "is_premium": isPremium,
        "profileImage": profileImage,
        "is_active": isActive,
        "is_admin": isAdmin,
        "poste_souhait": posteSouhait,
        "api_token": apiToken,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
