// ignore_for_file: non_constant_identifier_user_ids, non_constant_identifier_names

import 'dart:convert';

List<ModelCRM> allcrm(String str) =>
    List<ModelCRM>.from(json.decode(str).map((x) => ModelCRM.fromJson(x)));

String allcrmToJson(List<ModelCRM> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

String namaToko = '';
initState() {}

class ModelCRM {
  int? id;
  int? user_id;
  int? customer_id;
  int? aktivitas_id;
  int? visit_id;
  int? hasil_aktivitas;
  int? nominal_hasil;
  String? nomor_invoice;
  String? detail;
  String? tanggal_aktivitas;
  String? created_at;
  String? nama_toko;

  ModelCRM({
    this.id,
    this.user_id,
    this.customer_id,
    this.aktivitas_id,
    this.visit_id,
    this.hasil_aktivitas,
    this.nominal_hasil,
    this.nomor_invoice,
    this.detail,
    this.tanggal_aktivitas,
    this.created_at,
    this.nama_toko,
  });

  // ignore: avoid_types_as_parameter_names
  factory ModelCRM.fromJson(Map<String, dynamic> json) => ModelCRM(
        // id: json["id"] ?? 0,
        user_id: json["user_id"] ?? 0,
        customer_id: json["customer_id"] ?? 0,
        aktivitas_id: json["aktivitas_id"] ?? 0,
        visit_id: json["visit_id"] ?? 0,
        hasil_aktivitas: json["hasil_aktivitas"] ?? 0,
        nominal_hasil: json["nominal_hasil"] ?? 0,
        nomor_invoice: json["nomor_invoice"] ?? '',
        detail: json["detail"] ?? '',
        tanggal_aktivitas: json["tanggal_aktivitas"] ?? '',
        created_at: json["created_at"] ?? '',
        nama_toko: json["nama_toko"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "customer_id": customer_id,
        "aktivitas_id": aktivitas_id,
        "visit_id": visit_id,
        "hasil_aktivitas": hasil_aktivitas,
        "nominal_hasil": nominal_hasil,
        "nomor_invoice": nomor_invoice,
        "detail": detail,
        "tanggal_aktivitas": tanggal_aktivitas,
        "created_at": created_at,
        "nama_toko": nama_toko,
      };
}
