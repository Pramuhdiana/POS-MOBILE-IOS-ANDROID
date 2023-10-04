// ignore_for_file: non_constant_identifier_names, unnecessary_this

class CustomerMetierModel {
  final int id;
  final String name;
  final int? role;
  final String? alamat;
  final String? phone;
  final String? userId;
  final String? typeCustomer;
  final String? diskonCustomer;
  final String? customerBrand;
  final String? createdAt;
  final String? updatedAt;

  CustomerMetierModel({
    required this.id,
    required this.name,
    this.role,
    this.alamat,
    this.phone,
    this.userId,
    this.typeCustomer,
    this.diskonCustomer,
    this.customerBrand,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerMetierModel.fromJson(Map<String, dynamic> json) {
    return CustomerMetierModel(
      id: json['id'],
      name: json['name'] ?? 'No Name',
      role: json['role'] ?? 0,
      alamat: json['alamat'] ?? 'No Address',
      phone: json['phone'] ?? '',
      userId: json['user_id'] ?? '',
      typeCustomer: json['type_customer'] ?? '',
      diskonCustomer: json['diskon_customer'] ?? '',
      customerBrand: json['customer_brand'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  static List<CustomerMetierModel> fromJsonList(List list) {
    return list.map((item) => CustomerMetierModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(CustomerMetierModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
  String toId() => id.toString();
}
