// ignore_for_file: non_constant_identifier_user_ids, non_constant_identifier_names

import 'dart:convert';

List<ModelNotificationDummy> allcrm(String str) =>
    List<ModelNotificationDummy>.from(json
        .decode(str)
        .map((x) => ModelNotificationDummy.fromJson(x, String: null)));

String allcrmToJson(List<ModelNotificationDummy> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelNotificationDummy {
  int? id;
  String? title;
  String? body;
  int? status;
  String? created_at;

  ModelNotificationDummy({
    this.id,
    this.title,
    this.body,
    this.status,
    this.created_at,
  });

  // ignore: avoid_types_as_parameter_names
  factory ModelNotificationDummy.fromJson(Map<String, dynamic> json,
          // ignore: avoid_types_as_parameter_names
          {required String}) =>
      ModelNotificationDummy(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        body: json["body"] ?? 0,
        status: json["status"] ?? 0,
        created_at: json["created_at"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "status": status,
        "created_at": created_at,
      };
}
