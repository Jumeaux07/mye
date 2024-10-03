// To parse this JSON data, do
//
//     final positionModel = positionModelFromJson(jsonString);

import 'dart:convert';

PositionModel positionModelFromJson(String str) =>
    PositionModel.fromJson(json.decode(str));

String positionModelToJson(PositionModel data) => json.encode(data.toJson());

class PositionModel {
  String? placeId;
  String? osmId;
  String? osmType;
  String? licence;
  String? lat;
  String? lon;
  List<String>? boundingbox;
  String? positionModelClass;
  String? type;
  String? displayName;
  String? displayPlace;
  String? displayAddress;
  Address? address;

  PositionModel({
    this.placeId,
    this.osmId,
    this.osmType,
    this.licence,
    this.lat,
    this.lon,
    this.boundingbox,
    this.positionModelClass,
    this.type,
    this.displayName,
    this.displayPlace,
    this.displayAddress,
    this.address,
  });

  PositionModel copyWith({
    String? placeId,
    String? osmId,
    String? osmType,
    String? licence,
    String? lat,
    String? lon,
    List<String>? boundingbox,
    String? positionModelClass,
    String? type,
    String? displayName,
    String? displayPlace,
    String? displayAddress,
    Address? address,
  }) =>
      PositionModel(
        placeId: placeId ?? this.placeId,
        osmId: osmId ?? this.osmId,
        osmType: osmType ?? this.osmType,
        licence: licence ?? this.licence,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        boundingbox: boundingbox ?? this.boundingbox,
        positionModelClass: positionModelClass ?? this.positionModelClass,
        type: type ?? this.type,
        displayName: displayName ?? this.displayName,
        displayPlace: displayPlace ?? this.displayPlace,
        displayAddress: displayAddress ?? this.displayAddress,
        address: address ?? this.address,
      );

  factory PositionModel.fromJson(Map<String, dynamic> json) => PositionModel(
        placeId: json["place_id"],
        osmId: json["osm_id"],
        osmType: json["osm_type"],
        licence: json["licence"],
        lat: json["lat"],
        lon: json["lon"],
        boundingbox: json["boundingbox"] == null
            ? []
            : List<String>.from(json["boundingbox"]!.map((x) => x)),
        positionModelClass: json["class"],
        type: json["type"],
        displayName: json["display_name"],
        displayPlace: json["display_place"],
        displayAddress: json["display_address"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "osm_id": osmId,
        "osm_type": osmType,
        "licence": licence,
        "lat": lat,
        "lon": lon,
        "boundingbox": boundingbox == null
            ? []
            : List<dynamic>.from(boundingbox!.map((x) => x)),
        "class": positionModelClass,
        "type": type,
        "display_name": displayName,
        "display_place": displayPlace,
        "display_address": displayAddress,
        "address": address?.toJson(),
      };
}

class Address {
  String? name;
  String? state;
  String? country;
  String? countryCode;

  Address({
    this.name,
    this.state,
    this.country,
    this.countryCode,
  });

  Address copyWith({
    String? name,
    String? state,
    String? country,
    String? countryCode,
  }) =>
      Address(
        name: name ?? this.name,
        state: state ?? this.state,
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        name: json["name"],
        state: json["state"],
        country: json["country"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "state": state,
        "country": country,
        "country_code": countryCode,
      };
}
