// ignore_for_file: non_constant_identifier_names, unnecessary_this

class KodeKeluarbarang {
  final String kode_refrensi;

  KodeKeluarbarang({
    required this.kode_refrensi,
  });

  factory KodeKeluarbarang.fromJson(Map<String, dynamic> json) {
    return KodeKeluarbarang(
      kode_refrensi: json["kode_refrensi"] ?? "",
    );
  }

  static List<KodeKeluarbarang> fromJsonList(List list) {
    return list.map((item) => KodeKeluarbarang.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.kode_refrensi}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(KodeKeluarbarang model) {
    return this.kode_refrensi == model.kode_refrensi;
  }

  @override
  String toString() => kode_refrensi;
}
