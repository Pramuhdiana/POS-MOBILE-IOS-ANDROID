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
import 'package:e_shop/database/db_alltransaksi_baru.dart';
import 'package:e_shop/database/db_alltransaksi_new.dart';
import 'package:e_shop/database/db_alltransaksi_voucher.dart';
import 'package:e_shop/database/db_crm.dart';
import 'package:e_shop/database/model_allcustomer.dart';
import 'package:e_shop/database/model_alldetailtransaksi.dart';
import 'package:e_shop/database/model_allitems.dart';
import 'package:e_shop/database/model_allitems_retur.dart';
import 'package:e_shop/database/model_allitems_toko.dart';
import 'package:e_shop/database/model_alltransaksi.dart';
import 'package:e_shop/database/model_alltransaksi_baru.dart';
import 'package:e_shop/database/model_alltransaksi_new.dart';
import 'package:e_shop/database/model_alltransaksi_voucher.dart';
import 'package:e_shop/global/global.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/model_crm.dart';

class ApiServices {
  late BuildContext context;
  String token = sharedPreferences!.getString("token").toString();

  Future<List<Null>?> getAllItems() async {
    int? lengthIdSqlLite;

    await DbAllitems.db.getAll().then((value) {
      lengthIdSqlLite = value.length;
    });

    var url = ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    int? lengthIdApi = response.data.length;

    if (lengthIdSqlLite != lengthIdApi) {
      await DbAllitems.db.deleteAllitems();

      return (response.data as List).map((items) {
        DbAllitems.db.createAllitems(ModelAllitems.fromJson(items));
        print('insert to database allitems sales');
      }).toList();
    } else {
      print('database tidak ada perubahan (item sales)');
      return null;
    }
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

  // Future<List<Null>> getAllTransaksi() async {
  //   Response response = await Dio().get(
  //       ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint,
  //       options: Options(headers: {"Authorization": "Bearer $token"}));

  //   return (response.data as List).map((transaksi) {
  //     DbAlltransaksi.db
  //         .createAlltransaksi(ModelAlltransaksi.fromJson(transaksi));
  //     print('Inserting transaksi berhasil');
  //   }).toList();
  // }

  // Future<List<Null>> getAllTransaksiNew() async {
  //   Response response = await Dio().get(
  //       ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint,
  //       options: Options(headers: {"Authorization": "Bearer $token"}));
  //   print('status ${response.statusCode}');
  //   print('body ${response.data}');
  //   return (response.data as List).map((transaksi) {
  //     DbAlltransaksiNew.db
  //         .createAlltransaksiNew(ModelAlltransaksiNew.fromJson(transaksi));
  //   }).toList();
  // }

  // Future<List<Null>> getAllTransaksiNewVoucher() async {
  //   Response response = await Dio().get(
  //       ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint,
  //       options: Options(headers: {"Authorization": "Bearer $token"}));
  //   print('status ${response.statusCode}');
  //   print('body ${response.data}');
  //   return (response.data as List).map((transaksi) {
  //     DbAlltransaksiNewVoucher.db.createAlltransaksiNewVoucher(
  //         ModelAlltransaksiNewVoucher.fromJson(transaksi));
  //   }).toList();
  // }
  Future<List<Null>?> getAllTransaksiBaru() async {
    int? lengthIdSqlLite;

    await DbAlltransaksiBaru.db.getAll().then((value) {
      lengthIdSqlLite = value.length;
    });
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    int? lengthIdApi = response.data.length;
    if (lengthIdSqlLite != lengthIdApi) {
      await DbAlltransaksiBaru.db.deleteAlltransaksiBaru();

      return (response.data as List).map((transaksi) {
        DbAlltransaksiBaru.db
            .createAlltransaksiBaru(ModelAlltransaksiBaru.fromJson(transaksi));
      }).toList();
    } else {
      print('database tidak ada perubahan (all transaksi)');
      return null;
    }
  }

  List<dynamic> removeDuplicates(List<dynamic> items) {
    List<dynamic> uniqueItems = []; // uniqueList
    var uniqueNames = items
        .map((e) => e.kode_refrensi)
        .toSet(); //list if UniqueID to remove duplicates
    for (var e in uniqueNames) {
      uniqueItems.add(items.firstWhere((i) => i.kode_refrensi == e));
    } // populate uniqueItems with equivalent original Batch items
    return uniqueItems; //send back the unique items list
  }

  getAllKodekeluarbarang() async {
    List<String> kdRef = [];
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    for (var i = 0; i < response.data.length; i++) {
      kdRef.add(response.data[i]['kode_refrensi']);
    }
    kdRef =
        kdRef.toSet().toList(); //! remove duplicate dengan toset dan to list
    kdRef.removeWhere((value) => value == '');
    for (var i = 0; i < kdRef.length; i++) {
      print('kod : ${kdRef[i]}');
      DbAllKodekeluarbarang.db.createAllkodekeluarbarang(kdRef[i]);
    }
  }

  Future<List<Null>?> getAllDetailTransaksi() async {
    int? lengthIdSqlLite;

    await DbAlldetailtransaksi.db.getAll().then((value) {
      lengthIdSqlLite = value.length;
    });
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETdetailtransaksiendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    int? lengthIdApi = response.data.length;
    if (lengthIdSqlLite != lengthIdApi) {
      await DbAlldetailtransaksi.db.deleteAlldetailtransaksi();

      return (response.data as List).map((detailtransaksi) {
        DbAlldetailtransaksi.db.createAlldetailtransaksi(
            ModelAlldetailtransaksi.fromJson(detailtransaksi));
        print('Inserting detail transaksi berhasil');
      }).toList();
    } else {
      print('database tidak ada perubahan (detail transaksi)');
      return null;
    }
  }

  Future<List<Null>?> getAllCustomer() async {
    int? lengthIdSqlLite;

    await DbAllCustomer.db.getAll().then((value) {
      lengthIdSqlLite = value.length;
    });
    var url = ApiConstants.baseUrl + ApiConstants.GETcustomerendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    int? lengthIdApi = response.data.length;
    if (lengthIdSqlLite != lengthIdApi) {
      await DbAllCustomer.db.deleteAllcustomer();
      return (response.data as List).map((customer) {
        DbAllCustomer.db.createAllcustomer(ModelAllCustomer.fromJson(customer));
        print('insert to database allcustomer ');
      }).toList();
    } else {
      print('database tidak ada perubahan (all customer)');
      return null;
    }
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

  Future<List<Null>> getAllItemsTokoMetier() async {
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

  handelErr(var crm) {
    print('errorrr');
    DbCRM.db.createAllcrm(ModelCRM(
      user_id: crm['user_id'],
      customer_id: crm['customer_id'],
      aktivitas_id: crm['aktivitas_id'],
      visit_id: crm['visit_id'],
      hasil_aktivitas: crm['hasil_aktivitas'],
      nominal_hasil: crm['nominal_hasil'],
      nomor_invoice: crm['nomor_invoice'],
      detail: crm['detail'],
      tanggal_aktivitas: crm['tanggal_aktivitas'],
      created_at: crm['created_at'],
      nama_toko: 'toko',
    ));
  }

  Future<List<Null>?> getAllTCRM() async {
    int? lengthIdSqlLite;

    await DbCRM.db.getAll().then((value) {
      lengthIdSqlLite = value.length;
    });
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETcrmendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    int? lengthIdApi = response.data.length;
    print(lengthIdSqlLite);
    print('====');
    print(lengthIdApi);
    if (lengthIdSqlLite != lengthIdApi) {
      await DbCRM.db.deleteAllcrm();
      return (response.data as List).map((crm) {
        DbAllCustomer.db.getNameCustomer(crm['customer_id']).then(
          (value) {
            DbCRM.db.createAllcrm(ModelCRM(
              user_id: crm['user_id'],
              customer_id: crm['customer_id'],
              aktivitas_id: crm['aktivitas_id'],
              visit_id: crm['visit_id'],
              hasil_aktivitas: crm['hasil_aktivitas'],
              nominal_hasil: crm['nominal_hasil'],
              nomor_invoice: crm['nomor_invoice'],
              detail: crm['detail'],
              tanggal_aktivitas: crm['tanggal_aktivitas'],
              created_at: crm['created_at'],
              nama_toko: value,
            ));
          },
          // onError: handelErr(crm)
        );

        // DbCRM.db.createAllcrm(ModelCRM.fromJson(crm));
        print('Inserting CRM berhasil');
      }).toList();
    } else {
      print('database tidak ada perubahan (crm)');
      return null;
    }
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
