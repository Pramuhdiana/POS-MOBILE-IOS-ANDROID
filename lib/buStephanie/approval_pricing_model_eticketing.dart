import 'dart:convert';

List<PricingEticketingModel> allpricing(String str) =>
    List<PricingEticketingModel>.from(
        json.decode(str).map((x) => PricingEticketingModel.fromJson(x)));

String allpricingToJson(List<PricingEticketingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
initState() {}

class PricingEticketingModel {
  int? id;
  String? namaDesigner;
  String? namaToko;
  String? jenisBarang;
  String? brand;
  String? beratEmas;
  String? beratDiamond;
  int? pricePerCarat;
  int? priceAfterDiskon;
  int? estimasiHarga;
  String? createdAt;
  String? batu1;
  int? qtyBatu1;
  String? batu2;
  int? qtyBatu2;
  String? batu3;
  int? qtyBatu3;
  String? batu4;
  int? qtyBatu4;
  String? batu5;
  int? qtyBatu5;
  String? batu6;
  int? qtyBatu6;
  String? batu7;
  int? qtyBatu7;
  String? batu8;
  int? qtyBatu8;
  String? batu9;
  int? qtyBatu9;
  String? batu10;
  int? qtyBatu10;
  String? batu11;
  int? qtyBatu11;
  String? batu12;
  int? qtyBatu12;
  String? batu13;
  int? qtyBatu13;
  String? batu14;
  int? qtyBatu14;
  String? batu15;
  int? qtyBatu15;
  String? batu16;
  int? qtyBatu16;
  String? batu17;
  int? qtyBatu17;
  String? batu18;
  int? qtyBatu18;
  String? batu19;
  int? qtyBatu19;
  String? batu20;
  int? qtyBatu20;
  String? batu21;
  int? qtyBatu21;
  String? batu22;
  int? qtyBatu22;
  String? batu23;
  int? qtyBatu23;
  String? batu24;
  int? qtyBatu24;
  String? batu25;
  int? qtyBatu25;
  String? batu26;
  int? qtyBatu26;
  String? batu27;
  int? qtyBatu27;
  String? batu28;
  int? qtyBatu28;
  String? batu29;
  int? qtyBatu29;
  String? batu30;
  int? qtyBatu30;
  String? batu31;
  int? qtyBatu31;
  String? batu32;
  int? qtyBatu32;
  String? batu33;
  int? qtyBatu33;
  String? batu34;
  int? qtyBatu34;
  String? batu35;
  int? qtyBatu35;
  String? diambilId;
  String? statusApproval;
  String? statusGet;
  String? imageSales1;
  int? approvalHarga;
  String? imageSales2;
  String? imageDesign1;
  String? imageDesign2;
  String? jenisPengajuan;
  String? tanggalApprove;
  String? namaSales;
  String? namaCustomer;
  String? noteApprove;
  String? noGIA;
  String? jenisGIA;
  String? caratPcsGIA;
  String? hargaGIA;
  String? keterangan;
  String? budgetCustomer;
  String? notesCustomer;
  String? notesCustomer2;
  String? notesCustomer3;
  String? labour;
  String? emas;
  String? diamond;
  String? caratPcsBatu1;
  String? caratPcsBatu2;
  String? caratPcsBatu3;
  String? caratPcsBatu4;
  String? caratPcsBatu5;
  String? caratPcsBatu6;
  String? caratPcsBatu7;
  String? caratPcsBatu8;
  String? caratPcsBatu9;
  String? caratPcsBatu10;
  String? caratPcsBatu11;
  String? caratPcsBatu12;
  String? caratPcsBatu13;
  String? caratPcsBatu14;
  String? caratPcsBatu15;
  String? caratPcsBatu16;
  String? caratPcsBatu17;
  String? caratPcsBatu18;
  String? caratPcsBatu19;
  String? caratPcsBatu20;
  String? caratPcsBatu21;
  String? caratPcsBatu22;
  String? caratPcsBatu23;
  String? caratPcsBatu24;
  String? caratPcsBatu25;
  String? caratPcsBatu26;
  String? caratPcsBatu27;
  String? caratPcsBatu28;
  String? caratPcsBatu29;
  String? caratPcsBatu30;
  String? caratPcsBatu31;
  String? caratPcsBatu32;
  String? caratPcsBatu33;
  String? caratPcsBatu34;
  String? caratPcsBatu35;

  PricingEticketingModel(
      {this.id,
      this.namaDesigner,
      this.namaToko,
      this.jenisBarang,
      this.brand,
      this.beratEmas,
      this.beratDiamond,
      this.pricePerCarat,
      this.priceAfterDiskon,
      this.estimasiHarga,
      this.createdAt,
      this.batu1,
      this.qtyBatu1,
      this.batu2,
      this.qtyBatu2,
      this.batu3,
      this.qtyBatu3,
      this.batu4,
      this.qtyBatu4,
      this.batu5,
      this.qtyBatu5,
      this.batu6,
      this.qtyBatu6,
      this.batu7,
      this.qtyBatu7,
      this.batu8,
      this.qtyBatu8,
      this.batu9,
      this.qtyBatu9,
      this.batu10,
      this.qtyBatu10,
      this.batu11,
      this.qtyBatu11,
      this.batu12,
      this.qtyBatu12,
      this.batu13,
      this.qtyBatu13,
      this.batu14,
      this.qtyBatu14,
      this.batu15,
      this.qtyBatu15,
      this.batu16,
      this.qtyBatu16,
      this.batu17,
      this.qtyBatu17,
      this.batu18,
      this.qtyBatu18,
      this.batu19,
      this.qtyBatu19,
      this.batu20,
      this.qtyBatu20,
      this.batu21,
      this.qtyBatu21,
      this.batu22,
      this.qtyBatu22,
      this.batu23,
      this.qtyBatu23,
      this.batu24,
      this.qtyBatu24,
      this.batu25,
      this.qtyBatu25,
      this.batu26,
      this.qtyBatu26,
      this.batu27,
      this.qtyBatu27,
      this.batu28,
      this.qtyBatu28,
      this.batu29,
      this.qtyBatu29,
      this.batu30,
      this.qtyBatu30,
      this.batu31,
      this.qtyBatu31,
      this.batu32,
      this.qtyBatu32,
      this.batu33,
      this.qtyBatu33,
      this.batu34,
      this.qtyBatu34,
      this.batu35,
      this.qtyBatu35,
      this.diambilId,
      this.statusApproval,
      this.statusGet,
      this.imageSales1,
      this.approvalHarga,
      this.imageSales2,
      this.imageDesign1,
      this.imageDesign2,
      this.jenisPengajuan,
      this.tanggalApprove,
      this.namaSales,
      this.namaCustomer,
      this.noteApprove,
      this.noGIA,
      this.jenisGIA,
      this.caratPcsGIA,
      this.hargaGIA,
      this.keterangan,
      this.budgetCustomer,
      this.notesCustomer,
      this.notesCustomer2,
      this.notesCustomer3,
      this.labour,
      this.emas,
      this.diamond,
      this.caratPcsBatu1,
      this.caratPcsBatu2,
      this.caratPcsBatu3,
      this.caratPcsBatu4,
      this.caratPcsBatu5,
      this.caratPcsBatu6,
      this.caratPcsBatu7,
      this.caratPcsBatu8,
      this.caratPcsBatu9,
      this.caratPcsBatu10,
      this.caratPcsBatu11,
      this.caratPcsBatu12,
      this.caratPcsBatu13,
      this.caratPcsBatu14,
      this.caratPcsBatu15,
      this.caratPcsBatu16,
      this.caratPcsBatu17,
      this.caratPcsBatu18,
      this.caratPcsBatu19,
      this.caratPcsBatu20,
      this.caratPcsBatu21,
      this.caratPcsBatu22,
      this.caratPcsBatu23,
      this.caratPcsBatu24,
      this.caratPcsBatu25,
      this.caratPcsBatu26,
      this.caratPcsBatu27,
      this.caratPcsBatu28,
      this.caratPcsBatu29,
      this.caratPcsBatu30,
      this.caratPcsBatu31,
      this.caratPcsBatu32,
      this.caratPcsBatu33,
      this.caratPcsBatu34,
      this.caratPcsBatu35});

  PricingEticketingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    namaDesigner = json['namaDesigner'];
    namaToko = json['namaToko'];
    jenisBarang = json['jenisBarang'];
    brand = json['brand'];
    beratEmas = json['beratEmas'].toString();
    beratDiamond = json['beratDiamond'].toString();
    pricePerCarat = json['pricePerCarat'];
    priceAfterDiskon = json['priceAfterDiskon'];
    estimasiHarga = json['estimasiHarga'] ?? 0;
    createdAt = json['created_at'];
    batu1 = json['batu1'];
    qtyBatu1 = json['qtyBatu1'];
    batu2 = json['batu2'];
    qtyBatu2 = json['qtyBatu2'];
    batu3 = json['batu3'];
    qtyBatu3 = json['qtyBatu3'];
    batu4 = json['batu4'];
    qtyBatu4 = json['qtyBatu4'];
    batu5 = json['batu5'];
    qtyBatu5 = json['qtyBatu5'];
    batu6 = json['batu6'];
    qtyBatu6 = json['qtyBatu6'];
    batu7 = json['batu7'];
    qtyBatu7 = json['qtyBatu7'];
    batu8 = json['batu8'];
    qtyBatu8 = json['qtyBatu8'];
    batu9 = json['batu9'];
    qtyBatu9 = json['qtyBatu9'];
    batu10 = json['batu10'];
    qtyBatu10 = json['qtyBatu10'];
    batu11 = json['batu11'];
    qtyBatu11 = json['qtyBatu11'];
    batu12 = json['batu12'];
    qtyBatu12 = json['qtyBatu12'];
    batu13 = json['batu13'];
    qtyBatu13 = json['qtyBatu13'];
    batu14 = json['batu14'];
    qtyBatu14 = json['qtyBatu14'];
    batu15 = json['batu15'];
    qtyBatu15 = json['qtyBatu15'];
    batu16 = json['batu16'];
    qtyBatu16 = json['qtyBatu16'];
    batu17 = json['batu17'];
    qtyBatu17 = json['qtyBatu17'];
    batu18 = json['batu18'];
    qtyBatu18 = json['qtyBatu18'];
    batu19 = json['batu19'];
    qtyBatu19 = json['qtyBatu19'];
    batu20 = json['batu20'];
    qtyBatu20 = json['qtyBatu20'];
    batu21 = json['batu21'];
    qtyBatu21 = json['qtyBatu21'];
    batu22 = json['batu22'];
    qtyBatu22 = json['qtyBatu22'];
    batu23 = json['batu23'];
    qtyBatu23 = json['qtyBatu23'];
    batu24 = json['batu24'];
    qtyBatu24 = json['qtyBatu24'];
    batu25 = json['batu25'];
    qtyBatu25 = json['qtyBatu25'];
    batu26 = json['batu26'];
    qtyBatu26 = json['qtyBatu26'];
    batu27 = json['batu27'];
    qtyBatu27 = json['qtyBatu27'];
    batu28 = json['batu28'];
    qtyBatu28 = json['qtyBatu28'];
    batu29 = json['batu29'];
    qtyBatu29 = json['qtyBatu29'];
    batu30 = json['batu30'];
    qtyBatu30 = json['qtyBatu30'];
    batu31 = json['batu31'];
    qtyBatu31 = json['qtyBatu31'];
    batu32 = json['batu32'];
    qtyBatu32 = json['qtyBatu32'];
    batu33 = json['batu33'];
    qtyBatu33 = json['qtyBatu33'];
    batu34 = json['batu34'];
    qtyBatu34 = json['qtyBatu34'];
    batu35 = json['batu35'];
    qtyBatu35 = json['qtyBatu35'];
    diambilId = json['diambil_id'];
    statusApproval = json['status_approval'] ?? 0;
    statusGet = json['status_get'];
    imageSales1 = json['image_sales1'] ?? '';
    approvalHarga = json['approval_harga'] ?? 0;
    imageSales2 = json['image_sales2'] ?? '';
    imageDesign1 = json['image_design1'] ?? '';
    imageDesign2 = json['image_design2'] ?? '';
    jenisPengajuan = json['jenis_pengajuan'] ?? '';
    tanggalApprove = json['tanggal_approve'];
    namaSales = json['nama_sales'] ?? '';
    namaCustomer = json['nama_customer'] ?? '';
    noteApprove = json['note_approve'];
    noGIA = json['no_gia'];
    jenisGIA = json['jenis_gia'];
    caratPcsGIA = json['carat_pcs_gia'];
    hargaGIA = json['harga_gia'];
    keterangan = json['keterangan'];
    budgetCustomer = json['budget_customer'] ?? '0';
    notesCustomer = json['notes_customer'] ?? '';
    notesCustomer2 = json['notes_customer2'] ?? '';
    notesCustomer3 = json['notes_customer3'] ?? '';
    labour = json['labour'].toString();
    emas = json['emas'].toString();
    diamond = json['diamond'].toString();
    caratPcsBatu1 = (json['caratPcsBatu1'] ?? '0').toString();
    caratPcsBatu2 = (json['caratPcsBatu2'] ?? '0').toString();
    caratPcsBatu3 = (json['caratPcsBatu3'] ?? '0').toString();
    caratPcsBatu4 = (json['caratPcsBatu4'] ?? '0').toString();
    caratPcsBatu5 = (json['caratPcsBatu5'] ?? '0').toString();
    caratPcsBatu6 = (json['caratPcsBatu6'] ?? '0').toString();
    caratPcsBatu7 = (json['caratPcsBatu7'] ?? '0').toString();
    caratPcsBatu8 = (json['caratPcsBatu8'] ?? '0').toString();
    caratPcsBatu9 = (json['caratPcsBatu9'] ?? '0').toString();
    caratPcsBatu10 = (json['caratPcsBatu10'] ?? '0').toString();
    caratPcsBatu11 = (json['caratPcsBatu11'] ?? '0').toString();
    caratPcsBatu12 = (json['caratPcsBatu12'] ?? '0').toString();
    caratPcsBatu13 = (json['caratPcsBatu13'] ?? '0').toString();
    caratPcsBatu14 = (json['caratPcsBatu14'] ?? '0').toString();
    caratPcsBatu15 = (json['caratPcsBatu15'] ?? '0').toString();
    caratPcsBatu16 = (json['caratPcsBatu16'] ?? '0').toString();
    caratPcsBatu17 = (json['caratPcsBatu17'] ?? '0').toString();
    caratPcsBatu18 = (json['caratPcsBatu18'] ?? '0').toString();
    caratPcsBatu19 = (json['caratPcsBatu19'] ?? '0').toString();
    caratPcsBatu20 = (json['caratPcsBatu20'] ?? '0').toString();
    caratPcsBatu21 = (json['caratPcsBatu21'] ?? '0').toString();
    caratPcsBatu22 = (json['caratPcsBatu22'] ?? '0').toString();
    caratPcsBatu23 = (json['caratPcsBatu23'] ?? '0').toString();
    caratPcsBatu24 = (json['caratPcsBatu24'] ?? '0').toString();
    caratPcsBatu25 = (json['caratPcsBatu25'] ?? '0').toString();
    caratPcsBatu26 = (json['caratPcsBatu26'] ?? '0').toString();
    caratPcsBatu27 = (json['caratPcsBatu27'] ?? '0').toString();
    caratPcsBatu28 = (json['caratPcsBatu28'] ?? '0').toString();
    caratPcsBatu29 = (json['caratPcsBatu29'] ?? '0').toString();
    caratPcsBatu30 = (json['caratPcsBatu30'] ?? '0').toString();
    caratPcsBatu31 = (json['caratPcsBatu31'] ?? '0').toString();
    caratPcsBatu32 = (json['caratPcsBatu32'] ?? '0').toString();
    caratPcsBatu33 = (json['caratPcsBatu33'] ?? '0').toString();
    caratPcsBatu34 = (json['caratPcsBatu34'] ?? '0').toString();
    caratPcsBatu35 = (json['caratPcsBatu35'] ?? '0').toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['namaDesigner'] = namaDesigner;
    data['namaToko'] = namaToko;
    data['jenisBarang'] = jenisBarang;
    data['brand'] = brand;
    data['beratEmas'] = beratEmas;
    data['beratDiamond'] = beratDiamond;
    data['pricePerCarat'] = pricePerCarat;
    data['priceAfterDiskon'] = priceAfterDiskon;
    data['estimasiHarga'] = estimasiHarga;
    data['created_at'] = createdAt;
    data['batu1'] = batu1;
    data['qtyBatu1'] = qtyBatu1;
    data['batu2'] = batu2;
    data['qtyBatu2'] = qtyBatu2;
    data['batu3'] = batu3;
    data['qtyBatu3'] = qtyBatu3;
    data['batu4'] = batu4;
    data['qtyBatu4'] = qtyBatu4;
    data['batu5'] = batu5;
    data['qtyBatu5'] = qtyBatu5;
    data['batu6'] = batu6;
    data['qtyBatu6'] = qtyBatu6;
    data['batu7'] = batu7;
    data['qtyBatu7'] = qtyBatu7;
    data['batu8'] = batu8;
    data['qtyBatu8'] = qtyBatu8;
    data['batu9'] = batu9;
    data['qtyBatu9'] = qtyBatu9;
    data['batu10'] = batu10;
    data['qtyBatu10'] = qtyBatu10;
    data['batu11'] = batu11;
    data['qtyBatu11'] = qtyBatu11;
    data['batu12'] = batu12;
    data['qtyBatu12'] = qtyBatu12;
    data['batu13'] = batu13;
    data['qtyBatu13'] = qtyBatu13;
    data['batu14'] = batu14;
    data['qtyBatu14'] = qtyBatu14;
    data['batu15'] = batu15;
    data['qtyBatu15'] = qtyBatu15;
    data['batu16'] = batu16;
    data['qtyBatu16'] = qtyBatu16;
    data['batu17'] = batu17;
    data['qtyBatu17'] = qtyBatu17;
    data['batu18'] = batu18;
    data['qtyBatu18'] = qtyBatu18;
    data['batu19'] = batu19;
    data['qtyBatu19'] = qtyBatu19;
    data['batu20'] = batu20;
    data['qtyBatu20'] = qtyBatu20;
    data['batu21'] = batu21;
    data['qtyBatu21'] = qtyBatu21;
    data['batu22'] = batu22;
    data['qtyBatu22'] = qtyBatu22;
    data['batu23'] = batu23;
    data['qtyBatu23'] = qtyBatu23;
    data['batu24'] = batu24;
    data['qtyBatu24'] = qtyBatu24;
    data['batu25'] = batu25;
    data['qtyBatu25'] = qtyBatu25;
    data['batu26'] = batu26;
    data['qtyBatu26'] = qtyBatu26;
    data['batu27'] = batu27;
    data['qtyBatu27'] = qtyBatu27;
    data['batu28'] = batu28;
    data['qtyBatu28'] = qtyBatu28;
    data['batu29'] = batu29;
    data['qtyBatu29'] = qtyBatu29;
    data['batu30'] = batu30;
    data['qtyBatu30'] = qtyBatu30;
    data['batu31'] = batu31;
    data['qtyBatu31'] = qtyBatu31;
    data['batu32'] = batu32;
    data['qtyBatu32'] = qtyBatu32;
    data['batu33'] = batu33;
    data['qtyBatu33'] = qtyBatu33;
    data['batu34'] = batu34;
    data['qtyBatu34'] = qtyBatu34;
    data['batu35'] = batu35;
    data['qtyBatu35'] = qtyBatu35;
    data['diambil_id'] = diambilId;
    data['status_approval'] = statusApproval;
    data['status_get'] = statusGet;
    data['image_sales1'] = imageSales1;
    data['approval_harga'] = approvalHarga;
    data['image_sales2'] = imageSales2;
    data['image_design1'] = imageDesign1;
    data['image_design2'] = imageDesign2;
    data['jenis_pengajuan'] = jenisPengajuan;
    data['tanggal_approve'] = tanggalApprove;
    data['nama_sales'] = namaSales;
    data['nama_customer'] = namaCustomer;
    data['note_approve'] = noteApprove;
    data['no_gia'] = noGIA;
    data['jenis_gia'] = jenisGIA;
    data['carat_pcs_gia'] = caratPcsGIA;
    data['harga_gia'] = hargaGIA;
    data['keterangan'] = keterangan;
    data['budget_customer'] = budgetCustomer;
    data['notes_customer'] = notesCustomer;
    data['notes_customer2'] = notesCustomer2;
    data['notes_customer3'] = notesCustomer3;
    data['labour'] = labour;
    data['emas'] = emas;
    data['diamond'] = diamond;
    data['caratPcsBatu1'] = caratPcsBatu1;
    data['caratPcsBatu2'] = caratPcsBatu2;
    data['caratPcsBatu3'] = caratPcsBatu3;
    data['caratPcsBatu4'] = caratPcsBatu4;
    data['caratPcsBatu5'] = caratPcsBatu5;
    data['caratPcsBatu6'] = caratPcsBatu6;
    data['caratPcsBatu7'] = caratPcsBatu7;
    data['caratPcsBatu8'] = caratPcsBatu8;
    data['caratPcsBatu9'] = caratPcsBatu9;
    data['caratPcsBatu10'] = caratPcsBatu10;
    data['caratPcsBatu11'] = caratPcsBatu11;
    data['caratPcsBatu12'] = caratPcsBatu12;
    data['caratPcsBatu13'] = caratPcsBatu13;
    data['caratPcsBatu14'] = caratPcsBatu14;
    data['caratPcsBatu15'] = caratPcsBatu15;
    data['caratPcsBatu16'] = caratPcsBatu16;
    data['caratPcsBatu17'] = caratPcsBatu17;
    data['caratPcsBatu18'] = caratPcsBatu18;
    data['caratPcsBatu19'] = caratPcsBatu19;
    data['caratPcsBatu20'] = caratPcsBatu20;
    data['caratPcsBatu21'] = caratPcsBatu21;
    data['caratPcsBatu22'] = caratPcsBatu22;
    data['caratPcsBatu23'] = caratPcsBatu23;
    data['caratPcsBatu24'] = caratPcsBatu24;
    data['caratPcsBatu25'] = caratPcsBatu25;
    data['caratPcsBatu26'] = caratPcsBatu26;
    data['caratPcsBatu27'] = caratPcsBatu27;
    data['caratPcsBatu28'] = caratPcsBatu28;
    data['caratPcsBatu29'] = caratPcsBatu29;
    data['caratPcsBatu30'] = caratPcsBatu30;
    data['caratPcsBatu31'] = caratPcsBatu31;
    data['caratPcsBatu32'] = caratPcsBatu32;
    data['caratPcsBatu33'] = caratPcsBatu33;
    data['caratPcsBatu34'] = caratPcsBatu34;
    data['caratPcsBatu35'] = caratPcsBatu35;

    return data;
  }
}
