// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/global/global.dart';
import 'package:flutter/material.dart';

class CartMethods {
  addItemsToDatabase(
      String name,
      String item_no,
      String image_name,
      String description,
      String price,
      String posisi_id,
      String sales_id,
      String keterangan_barang,
      BuildContext context) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("items")
        .doc(name)
        .set({
      "name": name,
      "item_no": sales_id,
      "image_name": image_name,
      "slug": "",
      "description": description,
      "colors": "",
      "repeat": "",
      "price": price,
      "discount": "",
      "tag": "",
      "category": "",
      "posisi_id": posisi_id,
      "customer_id": '',
      "status_titipan": "",
      "brand_id": '',
      "qty": '',
      "user_id": '',
      "sales_id": sales_id,
      "keterangan_barang": keterangan_barang,
      "speaking_no": '',
      "job_order": '',
      "jenis_order": '',
      "salesUID": sharedPreferences!.getString("uid"),
      "salesName": sharedPreferences!.getString("name"),
      "publishedDate": DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection("items").doc(name).set({
        "name": name,
        "item_no": sales_id,
        "image_name": image_name,
        "slug": '',
        "description": description,
        "colors": '',
        "repeat": '',
        "price": price,
        "discount": '',
        "tag": '',
        "category": '',
        "posisi_id": posisi_id,
        "customer_id": '',
        "status_titipan": '',
        "brand_id": '',
        "qty": '',
        "user_id": '',
        "sales_id": sales_id,
        "keterangan_barang": keterangan_barang,
        "speaking_no": '',
        "job_order": '',
        "jenis_order": '',
        "salesUID": sharedPreferences!.getString("uid"),
        "salesName": sharedPreferences!.getString("name"),
        "publishedDate": DateTime.now(),
      });
    });
  }

  addItemsToDatabaseToko(
      String name,
      String image_name,
      String description,
      String price,
      String posisi_id,
      String keterangan_barang,
      BuildContext context) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("items")
        .doc(name)
        .set({
      "name": name,
      "image_name": image_name,
      "slug": "",
      "description": description,
      "colors": "",
      "repeat": "",
      "price": price,
      "discount": "",
      "tag": "",
      "category": "",
      "posisi_id": posisi_id,
      "customer_id": 1,
      "status_titipan": "",
      "brand_id": '',
      "qty": '',
      "user_id": '',
      "sales_id": "",
      "keterangan_barang": keterangan_barang,
      "speaking_no": '',
      "job_order": '',
      "jenis_order": '',
      "salesUID": sharedPreferences!.getString("uid"),
      "salesName": sharedPreferences!.getString("name"),
      "publishedDate": DateTime.now(),
    }).then((value) {
      FirebaseFirestore.instance.collection("items").doc(name).set({
        "name": name,
        "item_no": "",
        "image_name": image_name,
        "slug": '',
        "description": description,
        "colors": '',
        "repeat": '',
        "price": price,
        "discount": '',
        "tag": '',
        "category": '',
        "posisi_id": posisi_id,
        "customer_id": 1,
        "status_titipan": '',
        "brand_id": '',
        "qty": '',
        "user_id": '',
        "sales_id": "",
        "keterangan_barang": keterangan_barang,
        "speaking_no": '',
        "job_order": '',
        "jenis_order": '',
        "salesUID": sharedPreferences!.getString("uid"),
        "salesName": sharedPreferences!.getString("name"),
        "publishedDate": DateTime.now(),
      });
    });
  }
}
