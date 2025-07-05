// To parse this JSON data, do
//
//     final orderSummaryModel = orderSummaryModelFromJson(jsonString);

import 'dart:convert';

OrderSummaryModel orderSummaryModelFromJson(String str) =>
    OrderSummaryModel.fromJson(json.decode(str));

String orderSummaryModelToJson(OrderSummaryModel data) =>
    json.encode(data.toJson());

class OrderSummaryModel {
  String? message;
  String? messageType;
  Order? order;

  OrderSummaryModel({
    this.message,
    this.messageType,
    this.order,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) =>
      OrderSummaryModel(
        message: json["message"],
        messageType: json["messageType"],
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "messageType": messageType,
        "order": order?.toJson(),
      };
}

class Order {
  String? orderId;
  Customer? customer;
  Restaurant? restaurant;
  List<Item>? items;
  Status? status;
  Timeline? timeline;
  Payment? payment;
  Delivery? delivery;
  dynamic offers;
  Charges? charges;
  Metadata? metadata;

  Order({
    this.orderId,
    this.customer,
    this.restaurant,
    this.items,
    this.status,
    this.timeline,
    this.payment,
    this.delivery,
    this.offers,
    this.charges,
    this.metadata,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        restaurant: json["restaurant"] == null
            ? null
            : Restaurant.fromJson(json["restaurant"]),
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        timeline: json["timeline"] == null
            ? null
            : Timeline.fromJson(json["timeline"]),
        payment:
            json["payment"] == null ? null : Payment.fromJson(json["payment"]),
        delivery: json["delivery"] == null
            ? null
            : Delivery.fromJson(json["delivery"]),
        offers: json["offers"],
        charges:
            json["charges"] == null ? null : Charges.fromJson(json["charges"]),
        metadata: json["metadata"] == null
            ? null
            : Metadata.fromJson(json["metadata"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "customer": customer?.toJson(),
        "restaurant": restaurant?.toJson(),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "status": status?.toJson(),
        "timeline": timeline?.toJson(),
        "payment": payment?.toJson(),
        "delivery": delivery?.toJson(),
        "offers": offers,
        "charges": charges?.toJson(),
        "metadata": metadata?.toJson(),
      };
}

class Charges {
  int? subtotal;
  int? tax;
  double? delivery;
  int? surge;
  int? tip;
  int? discount;
  double? total;

  Charges({
    this.subtotal,
    this.tax,
    this.delivery,
    this.surge,
    this.tip,
    this.discount,
    this.total,
  });

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
        subtotal: json["subtotal"],
        tax: json["tax"],
        delivery: json["delivery"]?.toDouble(),
        surge: json["surge"],
        tip: json["tip"],
        discount: json["discount"],
        total: json["total"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "subtotal": subtotal,
        "tax": tax,
        "delivery": delivery,
        "surge": surge,
        "tip": tip,
        "discount": discount,
        "total": total,
      };
}

class Customer {
  String? id;
  String? name;
  String? email;
  String? phone;

  Customer({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
      };
}

class Delivery {
  DeliveryAddress? address;
  Location? location;
  dynamic agent;

  Delivery({
    this.address,
    this.location,
    this.agent,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        address: json["address"] == null
            ? null
            : DeliveryAddress.fromJson(json["address"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        agent: json["agent"],
      );

  Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
        "location": location?.toJson(),
        "agent": agent,
      };
}

class DeliveryAddress {
  String? street;
  String? area;
  String? landmark;
  String? city;
  String? state;
  String? pincode;
  String? country;

  DeliveryAddress({
    this.street,
    this.area,
    this.landmark,
    this.city,
    this.state,
    this.pincode,
    this.country,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        street: json["street"],
        area: json["area"],
        landmark: json["landmark"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "area": area,
        "landmark": landmark,
        "city": city,
        "state": state,
        "pincode": pincode,
        "country": country,
      };
}

class Location {
  String? type;
  List<double>? coordinates;

  Location({
    this.type,
    this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Item {
  String? productId;
  String? name;
  int? quantity;
  int? price;
  int? totalPrice;
  String? image;

  Item({
    this.productId,
    this.name,
    this.quantity,
    this.price,
    this.totalPrice,
    this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["productId"],
        name: json["name"],
        quantity: json["quantity"],
        price: json["price"],
        totalPrice: json["totalPrice"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "name": name,
        "quantity": quantity,
        "price": price,
        "totalPrice": totalPrice,
        "image": image,
      };
}

class Metadata {
  String? instructions;
  String? couponCode;

  Metadata({
    this.instructions,
    this.couponCode,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        instructions: json["instructions"],
        couponCode: json["couponCode"],
      );

  Map<String, dynamic> toJson() => {
        "instructions": instructions,
        "couponCode": couponCode,
      };
}

class Payment {
  String? method;
  double? amount;
  dynamic onlineDetails;
  int? walletUsed;

  Payment({
    this.method,
    this.amount,
    this.onlineDetails,
    this.walletUsed,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        method: json["method"],
        amount: json["amount"]?.toDouble(),
        onlineDetails: json["onlineDetails"],
        walletUsed: json["walletUsed"],
      );

  Map<String, dynamic> toJson() => {
        "method": method,
        "amount": amount,
        "onlineDetails": onlineDetails,
        "walletUsed": walletUsed,
      };
}

class Restaurant {
  String? id;
  String? name;
  RestaurantAddress? address;

  Restaurant({
    this.id,
    this.name,
    this.address,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        address: json["address"] == null
            ? null
            : RestaurantAddress.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address?.toJson(),
      };
}

class RestaurantAddress {
  String? street;
  String? city;
  String? state;
  String? zip;

  RestaurantAddress({
    this.street,
    this.city,
    this.state,
    this.zip,
  });

  factory RestaurantAddress.fromJson(Map<String, dynamic> json) =>
      RestaurantAddress(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        zip: json["zip"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "zip": zip,
      };
}

class Status {
  String? current;
  String? agentAssignment;

  Status({
    this.current,
    this.agentAssignment,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        current: json["current"],
        agentAssignment: json["agentAssignment"],
      );

  Map<String, dynamic> toJson() => {
        "current": current,
        "agentAssignment": agentAssignment,
      };
}

class Timeline {
  DateTime? orderTime;
  int? preparationTime;

  Timeline({
    this.orderTime,
    this.preparationTime,
  });

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
        orderTime: json["orderTime"] == null
            ? null
            : DateTime.parse(json["orderTime"]),
        preparationTime: json["preparationTime"],
      );

  Map<String, dynamic> toJson() => {
        "orderTime": orderTime?.toIso8601String(),
        "preparationTime": preparationTime,
      };
}
