class PastOrderModel {
  String? success;
  String? messageType;
  String? message;
  PastOrder? data;

  PastOrderModel({this.success, this.messageType, this.message, this.data});

  PastOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messageType = json['messageType'];
    message = json['message'];
    data = json['data'] != null ? PastOrder.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    data['messageType'] = messageType;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class PastOrder {
  List<Orders>? orders;

  PastOrder({this.orders});

  PastOrder.fromJson(Map<String, dynamic> json) {
    if (json['orders'] != null) {
      orders = <Orders>[];
      json['orders'].forEach((v) {
        orders!.add(Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  String? orderId;
  Restaurant? restaurant;
  String? orderDate;
  String? orderTime;
  String? orderStatus;
  String? isReorderAvailable;
  String? reorderUnavailableReason;
  List<UnavailableProduct>? unavailableProducts;
  List<OrderItems>? orderItems;
  num? totalAmount;

  Orders({
    this.orderId,
    this.restaurant,
    this.orderDate,
    this.orderTime,
    this.orderStatus,
    this.isReorderAvailable,
    this.reorderUnavailableReason,
    this.unavailableProducts,
    this.orderItems,
    this.totalAmount,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    restaurant = json['restaurant'] != null
        ? Restaurant.fromJson(json['restaurant'])
        : null;
    orderDate = json['orderDate'];
    orderTime = json['orderTime'];
    orderStatus = json['orderStatus'];
    isReorderAvailable = json['isReorderAvailable'];
    reorderUnavailableReason = json['reorderUnavailableReason'];

    if (json['unavailableProducts'] != null) {
      unavailableProducts = <UnavailableProduct>[];
      json['unavailableProducts'].forEach((v) {
        unavailableProducts!.add(UnavailableProduct.fromJson(v));
      });
    }

    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(OrderItems.fromJson(v));
      });
    }

    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['orderId'] = orderId;
    if (restaurant != null) {
      data['restaurant'] = restaurant!.toJson();
    }
    data['orderDate'] = orderDate;
    data['orderTime'] = orderTime;
    data['orderStatus'] = orderStatus;
    data['isReorderAvailable'] = isReorderAvailable;
    data['reorderUnavailableReason'] = reorderUnavailableReason;

    if (unavailableProducts != null) {
      data['unavailableProducts'] =
          unavailableProducts!.map((v) => v.toJson()).toList();
    }

    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = totalAmount;
    return data;
  }
}

class Restaurant {
  String? name;
  String? address;
  List<double>? location;

  Restaurant({this.name, this.address, this.location});

  Restaurant.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    location = json['location'] != null
        ? List<double>.from(json['location'].map((x) => x.toDouble()))
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['location'] = location;
    return data;
  }
}

class OrderItems {
  String? productId;
  String? name;
  int? quantity;
  int? price;
  int? totalPrice;
  String? image;

  OrderItems({
    this.productId,
    this.name,
    this.quantity,
    this.price,
    this.totalPrice,
    this.image,
  });

  OrderItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['productId'] = productId;
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    data['totalPrice'] = totalPrice;
    data['image'] = image;
    return data;
  }
}

class UnavailableProduct {
  String? productId;
  String? name;
  String? reason;

  UnavailableProduct({this.productId, this.name, this.reason});

  UnavailableProduct.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['productId'] = productId;
    data['name'] = name;
    data['reason'] = reason;
    return data;
  }
}
