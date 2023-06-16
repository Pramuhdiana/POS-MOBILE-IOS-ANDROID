// ignore_for_file: non_constant_identifier_names

class Sales {
  //membuat variabel
  int? id;
  String? full_name;
  String? name;
  String? email;
  int? role;
  int? role_sales;
  int? role_sales_brand;
  int? role_kurir;
  String? id_customer;
  String? phone;
  String? prev_password;
  int? address_id;
  DateTime? email_verified_at;
  DateTime? created_at;
  DateTime? updated_at;
  String? personal_access_tokens;

  //membuat object
  Sales({
    this.id,
    this.full_name,
    this.name,
    this.email,
    this.role,
    this.role_sales,
    this.role_sales_brand,
    this.role_kurir,
    this.id_customer,
    this.phone,
    this.prev_password,
    this.address_id,
    this.email_verified_at,
    this.created_at,
    this.updated_at,
    this.personal_access_tokens,
  });

  //isi variabel dengan data di database firestore
  Sales.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    full_name = json["full_name"];
    name = json["name"];
    email = json["email"];
    role = json["role"];
    role_sales = json["role_sales"];
    role_sales_brand = json["role_sales_brand"];
    role_kurir = json["role_kurir"];
    id_customer = json["id_customer"];
    phone = json["phone"];
    prev_password = json["prev_password"];
    address_id = json["address_id"];
    email_verified_at = json["email_verified_at"];
    created_at = json["created_at"];
    updated_at = json["updated_at"];
    personal_access_tokens = json["personal_access_tokens"];
  }
}
