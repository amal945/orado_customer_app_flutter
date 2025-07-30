import 'dart:convert';

OrderPriceSummaryModel orderPriceSummaryModelFromJson(String str) =>
    OrderPriceSummaryModel.fromJson(json.decode(str));

String orderPriceSummaryModelToJson(OrderPriceSummaryModel data) =>
    json.encode(data.toJson());

// "code" : "OUT_OF_DELIVERY_AREA",
// "error" : "Out of Delivery Area",
class OrderPriceSummaryModel {
  String? message;
  String? messageType;
  String? code;
  String? error;
  Data? data;

  OrderPriceSummaryModel({
    this.message,
    this.messageType,
    this.data,
    this.code,
    this.error,
  });

  factory OrderPriceSummaryModel.fromJson(Map<String, dynamic> json) =>
      OrderPriceSummaryModel(
        message: json["message"],
        messageType: json["messageType"],
        code: json["code"],
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "messageType": messageType,
        "data": data?.toJson(),
      };
}

class Data {
  String? deliveryFee;
  String? discount;
  String? distanceKm;
  String? subtotal;
  String? tax;
  String? totalTaxAmount;
  String? surgeFee;
  String? total;
  String? tipAmount;
  String? isSurge;
  String? surgeReason;
  String? offersApplied;
  String? isOffer;
  String? isPromo;
  PromoCodeInfo? promoCodeInfo;
  String? totalDiscount;
  List<Tax>? taxes;

  Data({
    this.deliveryFee,
    this.discount,
    this.distanceKm,
    this.subtotal,
    this.tax,
    this.totalTaxAmount,
    this.surgeFee,
    this.total,
    this.tipAmount,
    this.isSurge,
    this.surgeReason,
    this.offersApplied,
    this.isOffer,
    this.isPromo,
    this.promoCodeInfo,
    this.totalDiscount,
    this.taxes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        deliveryFee: json["deliveryFee"],
        discount: json["discount"],
        distanceKm: json["distanceKm"],
        subtotal: json["subtotal"],
        tax: json["tax"],
        totalTaxAmount: json["totalTaxAmount"],
        surgeFee: json["surgeFee"],
        total: json["total"],
        tipAmount: json["tipAmount"],
        isSurge: json["isSurge"],
        surgeReason: json["surgeReason"],
        offersApplied: json["offersApplied"],
        isOffer: json["isOffer"],
        isPromo: json["isPromo"],
        promoCodeInfo: json["promoCodeInfo"] == null
            ? null
            : PromoCodeInfo.fromJson(json["promoCodeInfo"]),
        totalDiscount: json["totalDiscount"],
        taxes: json["taxes"] == null
            ? []
            : List<Tax>.from(json["taxes"]!.map((x) => Tax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "deliveryFee": deliveryFee,
        "discount": discount,
        "distanceKm": distanceKm,
        "subtotal": subtotal,
        "tax": tax,
        "totalTaxAmount": totalTaxAmount,
        "surgeFee": surgeFee,
        "total": total,
        "tipAmount": tipAmount,
        "isSurge": isSurge,
        "surgeReason": surgeReason,
        "offersApplied": offersApplied,
        "isOffer": isOffer,
        "isPromo": isPromo,
        "promoCodeInfo": promoCodeInfo?.toJson(),
        "totalDiscount": totalDiscount,
        "taxes": taxes == null
            ? []
            : List<dynamic>.from(taxes!.map((x) => x.toJson())),
      };
}

class Tax {
  String? name;
  String? percentage;
  String? amount;

  Tax({
    this.name,
    this.percentage,
    this.amount,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        name: json["name"],
        percentage: json["percentage"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "percentage": percentage,
        "amount": amount,
      };
}

class PromoCodeInfo {
  String? code;
  String? applied;
  List<String>? messages;
  String? discount;

  PromoCodeInfo({
    this.code,
    this.applied,
    this.messages,
    this.discount,
  });

  factory PromoCodeInfo.fromJson(Map<String, dynamic> json) => PromoCodeInfo(
        code: json["code"],
        applied: json["applied"],
        messages:
            json["messages"] == null ? [] : List<String>.from(json["messages"]),
        discount: json["discount"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "applied": applied,
        "messages":
            messages == null ? [] : List<dynamic>.from(messages!.map((x) => x)),
        "discount": discount,
      };
}
