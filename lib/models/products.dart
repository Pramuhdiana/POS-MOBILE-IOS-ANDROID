// ignore_for_file: non_constant_identifier_names

class Products {
  String? id;
  String? name;
  String? item_no;
  String? image_name;
  String? slug;
  String? description;
  String? colors;
  String? repeat;
  String? price;
  String? discount;
  String? tag;
  String? category_id;
  String? category;
  String? posisi_id;
  String? customer_id;
  String? status_titipan;
  String? brand_id;
  String? qty;
  String? user_id;
  String? sales_id;
  String? keterangan_barang;
  String? speaking_no;
  String? job_order;
  String? jenis_order;
  String? sub_design_code;
  String? home_page;
  String? jenis_style;
  String? created_at;
  String? updated_at;
  String? salesUID;

  Products({
    required this.id,
    this.name,
    this.item_no,
    this.image_name,
    this.slug,
    this.description,
    this.colors,
    this.repeat,
    this.price,
    this.discount,
    this.tag,
    this.category_id,
    this.category,
    this.posisi_id,
    this.customer_id,
    this.status_titipan,
    this.brand_id,
    this.qty,
    this.user_id,
    this.sales_id,
    this.keterangan_barang,
    this.speaking_no,
    this.job_order,
    this.jenis_order,
    this.sub_design_code,
    this.home_page,
    this.jenis_style,
    this.created_at,
    this.updated_at,
    this.salesUID,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    item_no = json['item_no'];
    image_name = json['image_name'];
    description = json['description'];
    price = json['price'];
    keterangan_barang = json['keterangan_barang'];
    qty = json['qty'];
    brand_id = json['brand_id'];
    posisi_id = json['posisi_id'];
    salesUID = json['salesUID'];
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
