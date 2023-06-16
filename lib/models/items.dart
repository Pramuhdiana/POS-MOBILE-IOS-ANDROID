// ignore_for_file: non_constant_identifier_names

class Items {
  int? id;
  String? name;
  String? slug;
  String? image_name;
  String? description;
  int? price;
  String? category_id;
  int? posisi_id;
  String? customer_id;
  String? kode_refrensi;
  int? sales_id;
  int? brand_id;
  int? qty;
  String? status_titipan;
  String? keterangan_barang;
  String? created_at;
  String? updated_at;

  Items({
    required this.id,
    this.name,
    this.slug,
    this.image_name,
    this.description,
    this.price,
    this.category_id,
    this.posisi_id,
    this.customer_id,
    this.kode_refrensi,
    this.sales_id,
    this.brand_id,
    this.qty,
    this.status_titipan,
    this.keterangan_barang,
    this.created_at,
    this.updated_at,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        image_name: json['image_name'],
        description: json['description'],
        price: json['price'],
        category_id: json['category_id'],
        posisi_id: json['posisi_id'],
        customer_id: json['customer_id'],
        kode_refrensi: json['kode_refrensi'],
        sales_id: json['sales_id'],
        brand_id: json['brand_id'],
        qty: json['qty'],
        status_titipan: json['status_titipan'],
        keterangan_barang: json['keterangan_barang'],
        created_at: json['created_at'],
        updated_at: json['updated_at']);
  }
  // Map<String, dynamic> toJson() => {
  //       'id': id,
  //       'name': name,
  //       'lot': name,
  //       'item_no': item_no,
  //       'image_name': image_name,
  //       'description': description,
  //       'price': price,
  //       'keterangan_barang': keterangan_barang,
  //       'qty': qty,
  //       'brand_id': brand_id,
  //       'posisi_id': posisi_id,
  //       'salesUID': salesUID,
  //     };
}
