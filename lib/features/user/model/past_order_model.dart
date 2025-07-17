class PastOrderModel {
  bool? success;
  String? messageType;
  String? message;
  PastOrder? data;

  PastOrderModel({this.success, this.messageType, this.message, this.data});

  PastOrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messageType = json['messageType'];
    message = json['message'];
    data = json['data'] != null ? new PastOrder.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['messageType'] = this.messageType;
    data['message'] = this.message;
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
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
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
  List<OrderItems>? orderItems;
  num? totalAmount;

  Orders(
      {this.orderId,
      this.restaurant,
      this.orderDate,
      this.orderTime,
      this.orderStatus,
      this.orderItems,
      this.totalAmount});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    orderDate = json['orderDate'];
    orderTime = json['orderTime'];
    orderStatus = json['orderStatus'];
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    data['orderDate'] = this.orderDate;
    data['orderTime'] = this.orderTime;
    data['orderStatus'] = this.orderStatus;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = this.totalAmount;
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
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['location'] = this.location;
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

  OrderItems(
      {this.productId,
      this.name,
      this.quantity,
      this.price,
      this.totalPrice,
      this.image});

  OrderItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    totalPrice = json['totalPrice'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['totalPrice'] = this.totalPrice;
    data['image'] = this.image;
    return data;
  }
}
