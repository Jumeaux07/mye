class AbonnementModel {
  final int? id;
  final String? libelle;
  final int? price;
  final String? items;
  final int? status;
  final List? itemsList;

  AbonnementModel({
    this.id,
    this.libelle,
    this.price,
    this.items,
    this.status,
    this.itemsList,
  });

  AbonnementModel copyWith({
    int? id,
    String? libelle,
    int? price,
    String? items,
    int? status,
    List? itemsList,
  }) =>
      AbonnementModel(
        id: id ?? this.id,
        libelle: libelle ?? this.libelle,
        price: price ?? this.price,
        items: items ?? this.items,
        status: status ?? this.status,
        itemsList: itemsList ?? this.itemsList,
      );

  factory AbonnementModel.fromJson(Map<String, dynamic> json) =>
      AbonnementModel(
        id: json["id"],
        libelle: json["labelle"],
        price: json["price"],
        items: json["items"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "labelle": libelle,
        "price": price,
        "items": items,
        "status": status,
      };

  List<String> getItemList() {
    final List<String> itemsList = items?.split(',') ?? "".split(',');
    return itemsList;
  }
}
