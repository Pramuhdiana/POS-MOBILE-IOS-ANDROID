// ignore_for_file: prefer_void_to_null, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:e_shop/api/api_constant.dart';
import 'package:e_shop/global/global.dart';

class EmployeeApiProvider {
  String token = sharedPreferences!.getString("token").toString();
  Future<List<Null>> getAllItems() async {
    // var url = "https://hub.dummyapis.com/employee?noofRecords=10&idStarts=1001";
    // Response response = await Dio().get(url);
    var url = ApiConstants.baseUrl + ApiConstants.GETposSalesendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((items) {
      print('Inserting Items berhasil');
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
        'cutomer_id': items['cutomer_id'],
        'kode_refrensi': items['kode_refrensi'],
        'sales_id': items['sales_id'],
        'brand_id': items['brand_id'],
        'qty': items['qty'],
        'status_titipan': items['status_titipan'],
        'keterangan_barang': items['keterangan_barang'],
        'created_at': items['created_at'],
        'updated_at': items['updated_at'],
      });
      // DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }

  Future<List<Null>> getAllTransaksi() async {
    // var url = "https://hub.dummyapis.com/employee?noofRecords=10&idStarts=1001";
    // Response response = await Dio().get(url);
    Response response = await Dio().get(
        ApiConstants.baseUrl + ApiConstants.GETtransaksiendpoint,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((transaksi) {
      // print('Inserting $transaksi');
      print('Inserting transaksi berhasil');

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
        'total_rupiah': transaksi['total_rupiah'],
        'created_at': transaksi['created_at'],
        'updated_at': transaksi['updated_at'],
      });
      // DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }

  Future<List<Null>> getAllPosToko() async {
    // var url = "https://hub.dummyapis.com/employee?noofRecords=10&idStarts=1001";
    // Response response = await Dio().get(url);
    var url = ApiConstants.baseUrl + ApiConstants.GETposTokoendpoint;
    Response response = await Dio().get(url,
        options: Options(headers: {"Authorization": "Bearer $token"}));

    return (response.data as List).map((itemstoko) {
      // print('Inserting $itemstoko');
      print('Inserting ItemsToko berhasil');

      CollectionReference orderRef =
          FirebaseFirestore.instance.collection('allitems');
      orderRef.doc(itemstoko['name'].toString()).set({
        'id': itemstoko['id'],
        'name': itemstoko['name'],
        'slug': itemstoko['slug'],
        'image_name': itemstoko['image_name'],
        'description': itemstoko['description'],
        'price': itemstoko['price'],
        'category_id': itemstoko['category_id'],
        'posisi_id': itemstoko['posisi_id'],
        'cutomer_id': itemstoko['cutomer_id'],
        'kode_refrensi': itemstoko['kode_refrensi'],
        'sales_id': itemstoko['sales_id'],
        'brand_id': itemstoko['brand_id'],
        'qty': itemstoko['qty'],
        'status_titipan': itemstoko['status_titipan'],
        'keterangan_barang': itemstoko['keterangan_barang'],
        'created_at': itemstoko['created_at'],
        'updated_at': itemstoko['updated_at'],
      });
      // DBProvider.db.createEmployee(Employee.fromJson(employee));
    }).toList();
  }
}
