// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<ModelAllCustomer> allcustomer(String str) => List<ModelAllCustomer>.from(
    json.decode(str).map((x) => ModelAllCustomer.fromJson(x)));

String allcustomerToJson(List<ModelAllCustomer> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAllCustomer {
  int? id;
  String? name;
  int? role;
  String? alamat;
  String? phone;
  String? user_id;
  String? type_customer;
  String? diskon_customer;
  int? customer_brand;
  int? score;

  ModelAllCustomer({
    this.id,
    this.name,
    this.role,
    this.alamat,
    this.phone,
    this.user_id,
    this.type_customer,
    this.diskon_customer,
    this.customer_brand,
    this.score,
  });

  factory ModelAllCustomer.fromJson(Map<String, dynamic> json) =>
      ModelAllCustomer(
        id: json["id"] ?? 0,
        name: json["name"] ?? 'null',
        role: json["role"] ?? 0,
        alamat: json["alamat"] ?? 'null',
        phone: json["phone"] ?? '0',
        user_id: json["user_id"] ?? '0',
        type_customer: json["type_customer"] ?? '0',
        diskon_customer: json["diskon_customer"] ?? '1',
        customer_brand: json["customer_brand"] ?? 0,
        score: json["score"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "role": role,
        "alamat": alamat,
        "phone": phone,
        "user_id": user_id,
        "type_customer": type_customer,
        "diskon_customer": diskon_customer,
        "customer_brand": customer_brand,
        "score": score,
      };
}
