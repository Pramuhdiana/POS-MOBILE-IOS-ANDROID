// ignore_for_file: non_constant_identifier_names, unnecessary_this

class BlacklistModel {
  final int id;
  final String lot;

  BlacklistModel({
    required this.id,
    required this.lot,
  });

  factory BlacklistModel.fromJson(Map<String, dynamic> json) {
    return BlacklistModel(
      id: json["id"],
      lot: json["lot"],
    );
  }
}
