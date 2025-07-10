class FactureModel {
  final int? id;
  final String? reference;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? montant;
  final int? jours;
  final int? statut;
  final List<Paiement>? paiement;
  final List<Abonnement>? abonnement;

  FactureModel({
    this.id,
    this.reference,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.montant,
    this.jours,
    this.statut,
    this.paiement,
    this.abonnement,
  });

  FactureModel copyWith({
    int? id,
    String? reference,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? montant,
    int? jours,
    int? statut,
    List<Paiement>? paiement,
    List<Abonnement>? abonnement,
  }) =>
      FactureModel(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        montant: montant ?? this.montant,
        jours: jours ?? this.jours,
        statut: statut ?? this.statut,
        paiement: paiement ?? this.paiement,
        abonnement: abonnement ?? this.abonnement,
      );

  factory FactureModel.fromJson(Map<String, dynamic> json) => FactureModel(
        id: json["id"],
        reference: json["reference"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        montant: json["montant"],
        jours: json["jours"],
        statut: json["statut"],
        paiement: json["paiement"] == null
            ? []
            : List<Paiement>.from(
                json["paiement"]!.map((x) => Paiement.fromJson(x))),
        abonnement: json["abonnement"] == null
            ? []
            : List<Abonnement>.from(
                json["abonnement"]!.map((x) => Abonnement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference": reference,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "montant": montant,
        "jours": jours,
        "statut": statut,
        "paiement": paiement == null
            ? []
            : List<dynamic>.from(paiement!.map((x) => x.toJson())),
        "abonnement": abonnement == null
            ? []
            : List<dynamic>.from(abonnement!.map((x) => x.toJson())),
      };
}

class Abonnement {
  final int? id;
  final String? reference;
  final int? jours;
  final int? statut;
  final int? userId;
  final int? factureId;
  final DateTime? datefin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Abonnement({
    this.id,
    this.reference,
    this.jours,
    this.statut,
    this.userId,
    this.factureId,
    this.datefin,
    this.createdAt,
    this.updatedAt,
  });

  Abonnement copyWith({
    int? id,
    String? reference,
    int? jours,
    int? statut,
    int? userId,
    int? factureId,
    DateTime? datefin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Abonnement(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        jours: jours ?? this.jours,
        statut: statut ?? this.statut,
        userId: userId ?? this.userId,
        factureId: factureId ?? this.factureId,
        datefin: datefin ?? this.datefin,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Abonnement.fromJson(Map<String, dynamic> json) => Abonnement(
        id: json["id"],
        reference: json["reference"],
        jours: json["jours"],
        statut: json["statut"],
        userId: json["user_id"],
        factureId: json["facture_id"],
        datefin:
            json["datefin"] == null ? null : DateTime.parse(json["datefin"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference": reference,
        "jours": jours,
        "statut": statut,
        "user_id": userId,
        "facture_id": factureId,
        "datefin": datefin?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Paiement {
  final int? id;
  final String? reference;
  final int? userId;
  final int? factureId;
  final int? montant;
  final String? libelle;
  final String? moyenpaiement;
  final DateTime? datepaiement;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Paiement({
    this.id,
    this.reference,
    this.userId,
    this.factureId,
    this.montant,
    this.libelle,
    this.moyenpaiement,
    this.datepaiement,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Paiement copyWith({
    int? id,
    String? reference,
    int? userId,
    int? factureId,
    int? montant,
    String? libelle,
    String? moyenpaiement,
    DateTime? datepaiement,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Paiement(
        id: id ?? this.id,
        reference: reference ?? this.reference,
        userId: userId ?? this.userId,
        factureId: factureId ?? this.factureId,
        montant: montant ?? this.montant,
        libelle: libelle ?? this.libelle,
        moyenpaiement: moyenpaiement ?? this.moyenpaiement,
        datepaiement: datepaiement ?? this.datepaiement,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Paiement.fromJson(Map<String, dynamic> json) => Paiement(
        id: json["id"],
        reference: json["reference"],
        userId: json["user_id"],
        factureId: json["facture_id"],
        montant: json["montant"],
        libelle: json["libelle"],
        moyenpaiement: json["moyenpaiement"],
        datepaiement: json["datepaiement"] == null
            ? null
            : DateTime.parse(json["datepaiement"]),
        createdBy: json["created_by"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference": reference,
        "user_id": userId,
        "facture_id": factureId,
        "montant": montant,
        "libelle": libelle,
        "moyenpaiement": moyenpaiement,
        "datepaiement": datepaiement?.toIso8601String(),
        "created_by": createdBy,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
