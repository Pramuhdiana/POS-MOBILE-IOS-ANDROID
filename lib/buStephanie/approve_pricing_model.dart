import 'dart:convert';

List<ApprovePricingModel> allpricing(String str) =>
    List<ApprovePricingModel>.from(
        json.decode(str).map((x) => ApprovePricingModel.fromJson(x)));

String allpricingToJson(List<ApprovePricingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
initState() {}

class ApprovePricingModel {
  int? entryNo;
  String? jobOrder;
  String? marketingCode;
  String? lotNo;
  String? modelItem;
  String? productTypeCode;
  String? productTypeDesc;
  String? ringSize;
  String? giaCode;
  String? detailProduct;
  String? designLabourCode;
  String? salesDefinitionCode;
  String? salesDefinitionNo;
  String? sumAddition;
  String? diamondWeight;
  String? goldContent;
  String? metalCode;
  String? fgWeight;
  String? goldWeight;
  String? goldUnitCost;
  String? goldMF;
  String? stdGoldPrice;
  String? mfGoldPrice;
  String? mfDiamondPrice;
  String? mfLabourPrice;
  String? finalMF;
  String? otherPrice;
  String? finalPrice3USD;
  String? rateUSD;
  String? discountPercentage;
  String? goldAveragePrice;
  String? priceAfterDiscount;
  String? pricePerCarat;
  String? cadImageFileName;
  String? fgImageFileName;
  String? cadImageUrlPath;
  String? fgImageUrlPath;
  String? imagePath;
  String? imageBaseUrl;
  String? approvalStatus;
  String? approvalPrice;
  String? createdDate;
  String? editedDate;
  String? approvedDate;

  ApprovePricingModel(
      {this.entryNo,
      this.jobOrder,
      this.marketingCode,
      this.lotNo,
      this.modelItem,
      this.productTypeCode,
      this.productTypeDesc,
      this.ringSize,
      this.giaCode,
      this.detailProduct,
      this.designLabourCode,
      this.salesDefinitionCode,
      this.salesDefinitionNo,
      this.sumAddition,
      this.diamondWeight,
      this.goldContent,
      this.metalCode,
      this.fgWeight,
      this.goldWeight,
      this.goldUnitCost,
      this.goldMF,
      this.stdGoldPrice,
      this.mfGoldPrice,
      this.mfDiamondPrice,
      this.mfLabourPrice,
      this.finalMF,
      this.otherPrice,
      this.finalPrice3USD,
      this.rateUSD,
      this.discountPercentage,
      this.goldAveragePrice,
      this.priceAfterDiscount,
      this.pricePerCarat,
      this.cadImageFileName,
      this.fgImageFileName,
      this.cadImageUrlPath,
      this.fgImageUrlPath,
      this.imagePath,
      this.imageBaseUrl,
      this.approvalStatus,
      this.approvalPrice,
      this.createdDate,
      this.editedDate,
      this.approvedDate});

  factory ApprovePricingModel.fromJson(Map<String, dynamic> json) =>
      ApprovePricingModel(
        entryNo: json['entryNo'],
        jobOrder: json['jobOrder'],
        marketingCode: json['marketingCode'],
        lotNo: json['lotNo'],
        modelItem: json['modelItem'],
        productTypeCode: json['productTypeCode'],
        productTypeDesc: json['productTypeDesc'],
        ringSize: json['ringSize'].toString(),
        giaCode: json['giaCode'],
        detailProduct: json['detailProduct'],
        designLabourCode: json['designLabourCode'],
        salesDefinitionCode: json['salesDefinitionCode'],
        salesDefinitionNo: json['salesDefinitionNo'],
        sumAddition: json['sumAddition'],
        diamondWeight: json['diamondWeight'].toString(),
        goldContent: json['goldContent'].toString(),
        metalCode: json['metalCode'],
        fgWeight: json['fgWeight'].toString(),
        goldWeight: json['goldWeight'].toString(),
        goldUnitCost: json['goldUnitCost'].toString(),
        goldMF: json['goldMF'].toString(),
        stdGoldPrice: json['stdGoldPrice'].toString(),
        mfGoldPrice: json['mfGoldPrice'].toString(),
        mfDiamondPrice: json['mfDiamondPrice'].toString(),
        mfLabourPrice: json['mfLabourPrice'].toString(),
        finalMF: json['finalMF'].toString(),
        otherPrice: json['otherPrice'].toString(),
        finalPrice3USD: json['finalPrice3USD'].toString(),
        rateUSD: json['rateUSD'].toString(),
        discountPercentage: json['discountPercentage'].toString(),
        goldAveragePrice: json['goldAveragePrice'].toString(),
        priceAfterDiscount: json['priceAfterDiscount'].toString(),
        pricePerCarat: json['pricePerCarat'].toString(),
        cadImageFileName: json['cadImageFileName'],
        fgImageFileName: json['fgImageFileName'],
        cadImageUrlPath: json['cadImageUrlPath'],
        fgImageUrlPath: json['fgImageUrlPath'],
        imagePath: json['imagePath'],
        imageBaseUrl: json['imageBaseUrl'],
        approvalStatus: json['approvalStatus'],
        approvalPrice: json['approvalPrice'].toString(),
        createdDate: json['createdDate'],
        editedDate: json['editedDate'],
        approvedDate: json['approvedDate'],
      );

  Map<String, dynamic> toJson() => {
        "entryNo": entryNo,
        "jobOrder": jobOrder,
        "marketingCode": marketingCode,
        "lotNo": lotNo,
        "modelItem": modelItem,
        "productTypeCode": productTypeCode,
        "productTypeDesc": productTypeDesc,
        "ringSize": ringSize,
        "giaCode": giaCode,
        "detailProduct": detailProduct,
        "designLabourCode": designLabourCode,
        "salesDefinitionCode": salesDefinitionCode,
        "salesDefinitionNo": salesDefinitionNo,
        "sumAddition": sumAddition,
        "diamondWeight": diamondWeight,
        "goldContent": goldContent,
        "metalCode": metalCode,
        "fgWeight": fgWeight,
        "goldWeight": goldWeight,
        "goldUnitCost": goldUnitCost,
        "goldMF": goldMF,
        "stdGoldPrice": stdGoldPrice,
        "mfGoldPrice": mfGoldPrice,
        "mfDiamondPrice": mfDiamondPrice,
        "mfLabourPrice": mfLabourPrice,
        "finalMF": finalMF,
        "otherPrice": otherPrice,
        "finalPrice3USD": finalPrice3USD,
        "rateUSD": rateUSD,
        "discountPercentage": discountPercentage,
        "goldAveragePrice": goldAveragePrice,
        "priceAfterDiscount": priceAfterDiscount,
        "pricePerCarat": pricePerCarat,
        "cadImageFileName": cadImageFileName,
        "fgImageFileName": fgImageFileName,
        "cadImageUrlPath": cadImageUrlPath,
        "fgImageUrlPath": fgImageUrlPath,
        "imagePath": imagePath,
        "imageBaseUrl": imageBaseUrl,
        "approvalStatus": approvalStatus,
        "approvalPrice": approvalPrice,
        "createdDate": createdDate,
        "editedDate": editedDate,
        "approvedDate": approvedDate,
      };
}
