// ignore_for_file: non_constant_identifier_names, unnecessary_this

class VersionModel {
  final int id;
  final String version;

  VersionModel({
    required this.id,
    required this.version,
  });

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(
      id: json["id"],
      version: json["version"],
    );
  }

}
