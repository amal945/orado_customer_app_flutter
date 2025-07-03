import 'dart:convert';

OrderPriceSummaryModel orderPriceSummaryModelFromJson(String str) =>
    OrderPriceSummaryModel.fromJson(json.decode(str));

String orderPriceSummaryModelToJson(OrderPriceSummaryModel data) =>
    json.encode(data.toJson());

class OrderPriceSummaryModel {
  String? message;
  String? messageType;
  Data? data;

  OrderPriceSummaryModel({
    this.message,
    this.messageType,
    this.data,
  });

  factory OrderPriceSummaryModel.fromJson(Map<String, dynamic> json) =>
      OrderPriceSummaryModel(
        message: json["message"],
        messageType: json["messageType"],
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
