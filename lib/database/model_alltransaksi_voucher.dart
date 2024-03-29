// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';
import 'package:intl/intl.dart';

List<ModelAlltransaksiNewVoucher> allitemsnewvoucher(String str) =>
    List<ModelAlltransaksiNewVoucher>.from(
        json.decode(str).map((x) => ModelAlltransaksiNewVoucher.fromJson(x)));

String allitemsnewvoucherToJson(List<ModelAlltransaksiNewVoucher> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelAlltransaksiNewVoucher {
  String? invoices_number;
  int? user_id;
  int? customer_id;
  int? customer_metier;
  String? customer_beliberlian;
  int? jenisform_id;
  int? sales_id;
  int? total;
  int? total_quantity;
  String? total_rupiah;
  String? basic_discount;
  int? addesdiskon_rupiah;
  int? rate;
  int? nett;
  String? created_at;
  String? updated_at;
  String? user;
  String? customer;
  String? alamat;
  String? jenisform;
  int? voucherDiskon;
  String? month;
  String? year;
  String? status;

  ModelAlltransaksiNewVoucher({
    this.invoices_number,
    this.user_id,
    this.customer_id,
    this.customer_metier,
    this.customer_beliberlian,
    this.jenisform_id,
    this.sales_id,
    this.total,
    this.total_quantity,
    this.total_rupiah,
    this.basic_discount,
    this.addesdiskon_rupiah,
    this.rate,
    this.nett,
    this.created_at,
    this.updated_at,
    this.user,
    this.customer,
    this.alamat,
    this.jenisform,
    this.voucherDiskon,
    this.month,
    this.year,
    this.status,
  });

  factory ModelAlltransaksiNewVoucher.fromJson(Map<String, dynamic> json) =>
      ModelAlltransaksiNewVoucher(
          invoices_number: json["invoices_number"] ?? 'null',
          user_id: json["user_id"],
          customer_id: json["customer_id"],
          customer_metier: json["customer_metier"] ?? 0,
          customer_beliberlian: json["customer_beliberlian"] ?? '0',
          jenisform_id: json["jenisform_id"],
          sales_id: json["sales_id"] ?? 0,
          total: json["total"] ?? 0,
          total_quantity: json["total_quantity"] ?? 0,
          total_rupiah: json["total_rupiah"] ?? '0',
          basic_discount: (json["basic_discount"] ?? 0).toString(),
          addesdiskon_rupiah: json["addesdiskon_rupiah"] ?? 0,
          rate: json["rate"] ?? 0,
          nett: json["nett"] ?? 0,
          created_at: json["created_at"],
          updated_at: json["updated_at"],
          user: json["user"],
          customer: json["customer"],
          alamat: json["alamat"],
          jenisform: json["jenisform"],
          voucherDiskon: json["voucher_diskon"] ?? 0,
          month: DateFormat('M')
              .format(DateTime.parse(json["created_at"] ?? '13')),
          year: DateFormat('y')
              .format(DateTime.parse(json["created_at"] ?? '13')),
          status: 'oke');

  Map<String, dynamic> toJson() => {
        "invoices_number": invoices_number,
        "user_id": user_id,
        "customer_id": customer_id,
        "customer_metier": customer_metier,
        "customer_beliberlian": customer_beliberlian,
        "jenisform_id": jenisform_id,
        "sales_id": sales_id,
        "total": total,
        "total_quantity": total_quantity,
        "total_rupiah": total_rupiah,
        "basic_discount": basic_discount,
        "addesdiskon_rupiah": addesdiskon_rupiah,
        "rate": rate,
        "nett": nett,
        "created_at": created_at,
        "updated_at": updated_at,
        "user": user,
        "customer": customer,
        "alamat": alamat,
        "jenisform": jenisform,
        "voucher_diskon": voucherDiskon,
        "month": month,
        "year": year,
        "status": status,
      };
}
