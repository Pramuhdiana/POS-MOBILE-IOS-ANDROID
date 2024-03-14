// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<ModelAllitemsToko> allitemsToko(String str) =>
    List<ModelAllitemsToko>.from(
        json.decode(str).map((x) => ModelAllitemsToko.fromJson(x)));

String allitemsTokoToJson(List<ModelAllitemsToko> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAllitemsToko {
  int? id;
  String? name;
  String? slug;
  String? image_name;
  String? description;
  int? price;
  String? category_id;
  int? posisi_id;
  int? customer_id;
  String? kode_refrensi;
  int? sales_id;
  int? brand_id;
  int? qty;
  int? status_titipan;
  String? keterangan_barang;

  ModelAllitemsToko({
    this.id,
    this.name,
    this.slug,
    this.image_name,
    this.description,
    this.price,
    this.category_id,
    this.posisi_id,
    this.customer_id,
    this.kode_refrensi,
    this.sales_id,
    this.brand_id,
    this.qty,
    this.status_titipan,
    this.keterangan_barang,
  });

  factory ModelAllitemsToko.fromJson(Map<String, dynamic> json) =>
      ModelAllitemsToko(
        id: json["id"] ?? 0,
        name: json["name"],
        slug: json["slug"],
        image_name: json["image_name"],
        description: json["description"],
        price: json["price"],
        category_id: json["category_id"],
        posisi_id: json["posisi_id"],
        customer_id: json["customer_id"] ?? 0,
        kode_refrensi: json["kode_refrensi"],
        sales_id: json["sales_id"],
        brand_id: json["brand_id"] ?? 0,
        qty: json["qty"],
        status_titipan: json["status_titipan"] ?? 3,
        keterangan_barang: json["keterangan_barang"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "image_name": image_name,
        "description": description,
        "price": price,
        "category_id": category_id,
        "posisi_id": posisi_id,
        "customer_id": customer_id,
        "kode_refrensi": kode_refrensi,
        "sales_id": sales_id,
        "brand_id": brand_id,
        "qty": qty,
        "status_titipan": status_titipan,
        "keterangan_barang": keterangan_barang,
      };
}
