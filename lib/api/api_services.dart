// ignore_for_file: prefer_void_to_null, avoid_print, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/database/db_allcustomer.dart';
import 'package:e_shop/database/db_alldetailtransaksi.dart';
import 'package:e_shop/database/db_allitems.dart';
import 'package:e_shop/database/db_allitems_retur.dart';
import 'package:e_shop/database/db_allitems_toko.dart';
import 'package:e_shop/database/db_alltransaksi.dart';
import 'package:e_shop/database/model_allcustomer.dart';
import 'package:e_shop/database/model_alldetailtransaksi.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/database/model_alltransaksi.dart';
import 'package:e_shop/global/global.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  late BuildContext context;
  String token = sharedPreferences!.getString("token").toString();

  Future<List<Null>> getAllItems() async {
    var url = ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((items) {
      DbAllitems.db.createAllitems(ModelAllitems.fromJson(items));
      print('insert to database allitems sales');
    }).toList();
  }

  getUsers() async {
    var url = ApiConstants.baseUrl + ApiConstants.GETprofileendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('id', response.data['id'].toString());
    prefs.setString('full_name', response.data['full_name'].toString());
    prefs.setString('name', response.data['name'].toString());
    prefs.setString('email', response.data['email'].toString());
    prefs.setString('role', response.data['role'].toString());
    prefs.setString('role_sales', response.data['role_sales'].toString());
    prefs.setString(
        'role_sales_brand', response.data['role_sales_brand'].toString());
    prefs.setString('role_kurir', response.data['role_kurir'].toString());
    prefs.setString('id_customer', response.data['id_customer'].toString());
    prefs.setString('phone', response.data['phone'].toString());
    prefs.setString('prev_password', response.data['prev_password'].toString());
    prefs.setString('address_id', response.data['address_id'].toString());
    prefs.setString(
        'email_verified_at', response.data['email_verified_at'].toString());
    prefs.setString('created_at', response.data['created_at'].toString());
    prefs.setString('updated_at', response.data['updated_at'].toString());
    prefs.setString('personal_access_tokens',
        response.data['personal_access_tokens'].toString());
    print('Inserting Users to lokal berhasil');
  }

  Future<List<Null>> getAllTransaksi() async {
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((transaksi) {
      DbAlltransaksi.db
          .createAlltransaksi(ModelAlltransaksi.fromJson(transaksi));
      print('Inserting transaksi berhasil');
    }).toList();
  }

  Future<List<Null>> getAllKodekeluarbarang() async {
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((transaksi) {
      DbAllKodekeluarbarang.db.createAllkodekeluarbarang(
          ModelAllKodekeluarbarang.fromJson(transaksi));
      print('Inserting kode refrensi berhasil');
    }).toList();
  }

  Future<List<Null>> getAllDetailTransaksi() async {
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETdetailtransaksiendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return (response.data as List).map((detailtransaksi) {
      DbAlldetailtransaksi.db.createAlldetailtransaksi(
          ModelAlldetailtransaksi.fromJson(detailtransaksi));
      print('Inserting detail transaksi berhasil');
    }).toList();
  }

  Future<List<Null>> getAllCustomer() async {
    var url = ApiConstants.baseUrl + ApiConstants.GETcustomerendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return (response.data as List).map((customer) {
      // CollectionReference orderRef =
      //     FirebaseFirestore.instance.collection('allcustomer');
      // orderRef.doc(customer['name'].toString()).set({
      //   'id': customer['id'] ?? 0,
      //   'name': customer['name'] ?? 'null',
      //   'role': customer['role'] ?? '0',
      //   'alamat': customer['alamat'] ?? 'null',
      //   'phone': customer['phone'] ?? '0',
      //   'user_id': customer['user_id'] ?? '0',
      //   'type_customer': customer['type_customer'] ?? '0',
      //   'diskon_customer': customer['diskon_customer'] ?? '1',
      //   'customer_brand': customer['customer_brand'] ?? 0,
      //   'score': customer['score'] ?? 0,
      // });
      DbAllCustomer.db.createAllcustomer(ModelAllCustomer.fromJson(customer));
      print('insert to database allcustomer ');
    }).toList();
  }

  Future<List<Null>> getAllItemsToko() async {
    var url = ApiConstants.baseUrl + ApiConstants.GETposTokoendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return (response.data as List).map((itemstoko) {
      DbAllitemsToko.db
          .createAllitemsToko(ModelAllitemsToko.fromJson(itemstoko));
      print('insert to database allitems toko');
    }).toList();
  }

  Future<List<Null>> getAllItemsRetur() async {
    var url = ApiConstants.baseUrl + ApiConstants.GETposReturendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return (response.data as List).map((itemsretur) {
      DbAllitemsRetur.db
          .createAllitemsRetur(ModelAllitemsRetur.fromJson(itemsretur));
      print('insert to database allitems retur');
    }).toList();
  }
}

class ApiServicesFirebase {
  late BuildContext context;
  String token = sharedPreferences!.getString("token").toString();

  Future<List<Null>> getAllItems() async {
    var url = ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    print('add all item to firebase');
    return (response.data as List).map((items) {
      CollectionReference orderRef =
          FirebaseFirestore.instance.collection('allitems');
      orderRef.doc(items['name'].toString()).set({
        'id': items['id'],
        'name': items['name'],
        'slug': items['slug'],
        'image_name': items['image_name'],
        'description': items['description'],
        'price': items['price'],
        'category_id': items['category_id'],
        'posisi_id': items['posisi_id'],
        'customer_id': items['customer_id'].toString(),
        'kode_refrensi': items['kode_refrensi'],
        'sales_id': items['sales_id'],
        'brand_id': items['brand_id'] ?? 0,
        'qty': items['qty'],
        'status_titipan': items['status_titipan'] ?? 99,
        'keterangan_barang': items['keterangan_barang'],
        'created_at': items['created_at'],
        'updated_at': items['updated_at'],
      });
    }).toList();
  }

  Future<List<Null>> getAllTransaksi() async {
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    print('add all transaksi to firebase');
    return (response.data as List).map((transaksi) {
      CollectionReference orderRef =
          FirebaseFirestore.instance.collection('alltransaksi');
      orderRef.doc(transaksi['invoices_number'].toString()).set({
        'invoices_number': transaksi['invoices_number'],
        'user_id': transaksi['user_id'],
        'customer_id': transaksi['customer_id'],
        'customer_metier': transaksi['customer_metier'],
        'jenisform_id': transaksi['jenisform_id'],
        'sales_id': transaksi['sales_id'],
        'total': transaksi['total'],
        'total_quantity': transaksi['total_quantity'],
        'total_rupiah': transaksi['total_rupiah'] ?? '0',
        'basic_discount': transaksi['basic_discount'] ?? 0,
        'addesdiskon_rupiah': transaksi['addesdiskon_rupiah'] ?? 0,
        'rate': transaksi['rate'] ?? 0,
        'nett': transaksi['nett'] ?? 0,
        'created_at': transaksi['created_at'],
        'updated_at': transaksi['updated_at'],
        'user': transaksi['user'],
        'customer': transaksi['customer'],
        'alamat': transaksi['alamat'],
        'jenisform': transaksi['jenisform'],
      });
    }).toList();
  }

  Future<List<Null>> getAllDetailTransaksi() async {
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETdetailtransaksiendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((detailtransaksi) {
      CollectionReference orderRef =
          FirebaseFirestore.instance.collection('alltransaksi');
      print('add all detail transaksi to firebase');
      orderRef
          .doc(detailtransaksi['invoices_number'].toString())
          .collection("alldetailtransaksi")
          .doc(detailtransaksi['name'])
          .set({
        'invoices_number': detailtransaksi['invoices_number'] ?? 'null',
        'product_id': detailtransaksi['product_id'],
        'user_id': detailtransaksi['user_id'],
        'kode_refrensi': detailtransaksi['kode_refrensi'] ?? 'null',
        'name': detailtransaksi['name'],
        'price': detailtransaksi['price'],
        'description': detailtransaksi['description'],
        'image_name': detailtransaksi['image_name'],
        'keterangan_barang': detailtransaksi['keterangan_barang'] ?? 'null',
      }).then((value) {
        FirebaseFirestore.instance
            .collection("alldetailtransaksi")
            .doc(detailtransaksi['name'].toString())
            .set({
          'invoices_number': detailtransaksi['invoices_number'] ?? 'null',
          'product_id': detailtransaksi['product_id'],
          'user_id': detailtransaksi['user_id'],
          'kode_refrensi': detailtransaksi['kode_refrensi'] ?? 'null',
          'name': detailtransaksi['name'],
          'price': detailtransaksi['price'],
          'description': detailtransaksi['description'],
          'image_name': detailtransaksi['image_name'],
          'keterangan_barang': detailtransaksi['keterangan_barang'] ?? 'null',
        });
      });
    }).toList();
  }

  Future<List<Null>> getAllItemsToko() async {
    var url = ApiConstants.baseUrl + ApiConstants.GETposTokoendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((itemstoko) {
      print('add all item toko to firebase');
      CollectionReference orderRef =
          FirebaseFirestore.instance.collection('allitemstoko');
      orderRef.doc(itemstoko['name'].toString()).set({
        'id': itemstoko['id'],
        'name': itemstoko['name'],
        'slug': itemstoko['slug'],
        'image_name': itemstoko['image_name'],
        'description': itemstoko['description'],
        'price': itemstoko['price'],
        'category_id': itemstoko['category_id'],
        'posisi_id': itemstoko['posisi_id'],
        'customer_id': itemstoko['customer_id'].toString(),
        'kode_refrensi': itemstoko['kode_refrensi'],
        'sales_id': itemstoko['sales_id'],
        'brand_id': itemstoko['brand_id'] ?? 9999,
        'qty': itemstoko['qty'],
        'status_titipan': itemstoko['status_titipan'] ?? 99,
        'keterangan_barang': itemstoko['keterangan_barang'],
        'created_at': itemstoko['created_at'],
        'updated_at': itemstoko['updated_at'],
      });
    }).toList();
  }
}
