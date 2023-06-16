// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

List<ModelAllitems> allitems(String str) => List<ModelAllitems>.from(
    json.decode(str).map((x) => ModelAllitems.fromJson(x)));

String allitemsToJson(List<ModelAllitems> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAllitems {
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

  ModelAllitems({
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

  factory ModelAllitems.fromJson(Map<String, dynamic> json) => ModelAllitems(
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
        status_titipan: json["status_titipan"] ?? 0,
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

List<ModelAllKodekeluarbarang> allkodekeluarbarang(String str) =>
    List<ModelAllKodekeluarbarang>.from(
        json.decode(str).map((x) => ModelAllKodekeluarbarang.fromJson(x)));

String allkodekeluarbarangToJson(List<ModelAllKodekeluarbarang> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAllKodekeluarbarang {
  String? kode_refrensi;

  ModelAllKodekeluarbarang({
    this.kode_refrensi,
  });

  factory ModelAllKodekeluarbarang.fromJson(Map<String, dynamic> json) =>
      ModelAllKodekeluarbarang(
        kode_refrensi: json["kode_refrensi"] ?? 'null',
      );

  Map<String, dynamic> toJson() => {
        "kode_refrensi": kode_refrensi,
      };
}
