class NotificationModel {
  final String? id;
  final String? type;
  final String? notifiableType;
  final int? notifiableId;
  final NotificationModelData? data;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NotificationModel({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    required this.createdAt,
    this.updatedAt,
  });

  NotificationModel copyWith({
    String? id,
    String? type,
    String? notifiableType,
    int? notifiableId,
    NotificationModelData? data,
    DateTime? readAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) =>
      NotificationModel(
        id: id ?? this.id,
        type: type ?? this.type,
        notifiableType: notifiableType ?? this.notifiableType,
        notifiableId: notifiableId ?? this.notifiableId,
        data: data ?? this.data,
        readAt: readAt ?? this.readAt,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: json["data"] == null
            ? null
            : NotificationModelData.fromJson(json["data"]),
        readAt:
            json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data?.toJson(),
        "read_at": readAt?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class NotificationModelData {
  final String? title;
  final String? message;
  final DataData? data;

  NotificationModelData({
    this.title,
    this.message,
    this.data,
  });

  NotificationModelData copyWith({
    String? title,
    String? message,
    DataData? data,
  }) =>
      NotificationModelData(
        title: title ?? this.title,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory NotificationModelData.fromJson(Map<String, dynamic> json) =>
      NotificationModelData(
        title: json["title"],
        message: json["message"],
        data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataData {
  final String? event;
  final String? image;
  final String? requestid;

  DataData({
    this.event,
    this.image,
    this.requestid,
  });

  DataData copyWith({
    String? event,
    String? image,
    String? requestid,
  }) =>
      DataData(
        event: event ?? this.event,
        image: image ?? this.image,
        requestid: requestid ?? this.requestid,
      );

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        event: json["event"],
        image: json["image"],
        requestid: json["requestid"],
      );

  Map<String, dynamic> toJson() => {
        "event": event,
        "image": image,
        "requestid": requestid,
      };
}
