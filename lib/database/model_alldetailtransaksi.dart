// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<ModelAlldetailtransaksi> allitems(String str) =>
    List<ModelAlldetailtransaksi>.from(
        json.decode(str).map((x) => ModelAlldetailtransaksi.fromJson(x)));

String allitemsToJson(List<ModelAlldetailtransaksi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAlldetailtransaksi {
  String? invoices_number;
  int? product_id;
  int? user_id;
  String? kode_refrensi;
  String? name;
  int? price;
  String? description;
  String? image_name;
  String? keterangan_barang;

  ModelAlldetailtransaksi({
    this.invoices_number,
    this.product_id,
    this.user_id,
    this.kode_refrensi,
    this.name,
    this.price,
    this.description,
    this.image_name,
    this.keterangan_barang,
  });

  factory ModelAlldetailtransaksi.fromJson(Map<String, dynamic> json) =>
      ModelAlldetailtransaksi(
        invoices_number: json["invoices_number"] ?? 'null',
        product_id: json["product_id"],
        user_id: json["user_id"],
        kode_refrensi: json["kode_refrensi"] ?? 'null',
        name: json["name"],
        price: json["price"],
        description: json["description"],
        image_name: json["image_name"],
        keterangan_barang: json["keterangan_barang"] ?? 'null',
      );

  Map<String, dynamic> toJson() => {
        "invoices_number": invoices_number,
        "product_id": product_id,
        "user_id": user_id,
        "kode_refrensi": kode_refrensi,
        "name": name,
        "price": price,
        "description": description,
        "image_name": image_name,
        "keterangan_barang": keterangan_barang,
      };
}
