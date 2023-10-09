// ignore_for_file: non_constant_identifier_names

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
  double? ringSize;
  String? giaCode;
  String? detailProduct;
  String? designLabourCode;
  String? salesDefinitionCode;
  String? salesDefinitionNo;
  String? sumAddition;
  double? diamondWeight;
  double? goldContent;
  String? metalCode;
  double? fgWeight;
  double? goldWeight;
  double? goldUnitCost;
  double? goldMF;
  double? stdGoldPrice;
  double? mfGoldPrice;
  double? mfDiamondPrice;
  double? mfLabourPrice;
  double? finalMF;
  double? otherPrice;
  double? finalPrice3USD;
  double? rateUSD;
  double? discountPercentage;
  double? goldAveragePrice;
  double? priceAfterDiscount;
  double? pricePerCarat;
  String? cadImageFileName;
  String? fgImageFileName;
  String? cadImageUrlPath;
  String? fgImageUrlPath;
  String? imagePath;
  String? imageBaseUrl;
  String? approvalStatus;
  double? approvalPrice;
  String? createdDate;
  String? editedDate;
  String? approvedDate;
  String? budgetCustomer;
  double? grandSTDLabourPrice;
  double? grandSTDDiamondPrice;
  String? eticketingId;
  double? customerBudget;
  double? eticketingEstimatedPrice;
  double? eticketingApprovalPrice;
  double? eticketingTargetWeight;
  double? eticketingTargetDiamond;

  ApprovePricingModel({
    this.entryNo,
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
    this.approvedDate,
    this.budgetCustomer,
    this.grandSTDLabourPrice,
    this.grandSTDDiamondPrice,
    this.eticketingId,
    this.customerBudget,
    this.eticketingEstimatedPrice,
    this.eticketingApprovalPrice,
    this.eticketingTargetWeight,
    this.eticketingTargetDiamond,
  });

  factory ApprovePricingModel.fromJson(Map<String, dynamic> json) =>
      ApprovePricingModel(
        entryNo: json['entryNo'],
        jobOrder: json['jobOrder'],
        marketingCode: json['marketingCode'],
        lotNo: json['lotNo'],
        modelItem: json['modelItem'],
        productTypeCode: json['productTypeCode'],
        productTypeDesc: json['productTypeDesc'],
        ringSize: json['ringSize'],
        giaCode: json['giaCode'],
        detailProduct: json['detailProduct'],
        designLabourCode: json['designLabourCode'],
        salesDefinitionCode: json['salesDefinitionCode'],
        salesDefinitionNo: json['salesDefinitionNo'],
        sumAddition: json['sumAddition'],
        diamondWeight: json['diamondWeight'],
        goldContent: json['goldContent'],
        metalCode: json['metalCode'],
        fgWeight: json['fgWeight'],
        goldWeight: json['goldWeight'],
        goldUnitCost: json['goldUnitCost'],
        goldMF: json['goldMF'],
        stdGoldPrice: json['stdGoldPrice'],
        mfGoldPrice: json['mfGoldPrice'],
        mfDiamondPrice: json['mfDiamondPrice'],
        mfLabourPrice: json['mfLabourPrice'],
        finalMF: json['finalMF'],
        otherPrice: json['otherPrice'],
        finalPrice3USD: json['finalPrice3USD'],
        rateUSD: json['rateUSD'],
        discountPercentage: json['discountPercentage'],
        goldAveragePrice: json['goldAveragePrice'],
        priceAfterDiscount: json['priceAfterDiscount'],
        pricePerCarat: json['pricePerCarat'],
        cadImageFileName: json['cadImageFileName'],
        fgImageFileName: json['fgImageFileName'],
        cadImageUrlPath: json['cadImageUrlPath'],
        fgImageUrlPath: json['fgImageUrlPath'],
        imagePath: json['imagePath'],
        imageBaseUrl: json['imageBaseUrl'],
        approvalStatus: json['approvalStatus'],
        approvalPrice: json['approvalPrice'],
        createdDate: json['createdDate'],
        editedDate: json['editedDate'],
        approvedDate: json['approvedDate'],
        budgetCustomer: (json['customerBudget'] ?? '0').toString(),
        grandSTDLabourPrice: json['grandSTDLabourPrice'],
        grandSTDDiamondPrice: json['grandSTDDiamondPrice'],
        eticketingId: (json['eticketingId'] ?? '-1').toString(),
        customerBudget: json['customerBudget'] ?? 0,
        eticketingEstimatedPrice: json['eticketingEstimatedPrice'] ?? 0,
        eticketingApprovalPrice: json['eticketingApprovalPrice'] ?? 0,
        eticketingTargetWeight: json['eticketingApprovalPrice'] ?? 0,
        eticketingTargetDiamond: json['eticketingTargetDiamond'] ?? 0,
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
        "budgetCustomer": budgetCustomer,
        "grandSTDLabourPrice": grandSTDLabourPrice,
        "grandSTDDiamondPrice": grandSTDDiamondPrice,
        "eticketingId": eticketingId,
        "customerBudget": customerBudget,
        "eticketingEstimatedPrice": eticketingEstimatedPrice,
        "eticketingApprovalPrice": eticketingApprovalPrice,
        "eticketingTargetWeight": eticketingTargetWeight,
        "eticketingTargetDiamond": eticketingTargetDiamond,
      };
}
