// ignore_for_file: non_constant_identifier_user_ids, non_constant_identifier_names

import 'dart:convert';

List<ModelCRM> allcrm(String str) => List<ModelCRM>.from(
    json.decode(str).map((x) => ModelCRM.fromJson(x, String: null)));

String allcrmToJson(List<ModelCRM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelCRM {
  int? id;
  String? user_id;
  int? customer_id;
  String? tanggal_aktivitas;
  String? aktivitas_id;
  String? visit_id;
  String? hasil_aktivitas;
  int? nominal_hasil;
  String? nomor_invoice;
  String? detail;
  String? nama_toko;

  ModelCRM({
    this.id,
    this.user_id,
    this.customer_id,
    this.tanggal_aktivitas,
    this.aktivitas_id,
    this.visit_id,
    this.hasil_aktivitas,
    this.nominal_hasil,
    this.nomor_invoice,
    this.detail,
    this.nama_toko,
  });

  // ignore: avoid_types_as_parameter_names
  factory ModelCRM.fromJson(Map<String, dynamic> json, {required String}) =>
      ModelCRM(
        id: json["id"] ?? 0,
        user_id: json["user_id"] ?? '0',
        customer_id: json["customer_id"] ?? 0,
        tanggal_aktivitas: json["tanggal_aktivitas"] ?? '',
        aktivitas_id: json["aktivitas_id"] ?? '0',
        visit_id: json["visit_id"] ?? '0',
        hasil_aktivitas: json["hasil_aktivitas"] ?? '0',
        nominal_hasil: json["nominal_hasil"] ?? 0,
        nomor_invoice: json["nomor_invoice"] ?? '',
        detail: json["detail"] ?? '',
        nama_toko: json["nama_toko"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "customer_id": customer_id,
        "tanggal_aktivitas": tanggal_aktivitas,
        "aktivitas_id": aktivitas_id,
        "visit_id": visit_id,
        "hasil_aktivitas": hasil_aktivitas,
        "nominal_hasil": nominal_hasil,
        "nomor_invoice": nomor_invoice,
        "detail": detail,
        "nama_toko": nama_toko,
      };
}
