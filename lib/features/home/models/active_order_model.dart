class ActiveOrderModel {
  String? sId;
  Customer? customer;
  Restaurant? restaurant;
  List<OrderItems>? orderItems;
  String? orderStatus;
  AssignedAgent? assignedAgent;
  int? isAgentAssigned;
  int? subtotal;
  String? orderTime;

  ActiveOrderModel(
      {this.sId,
        this.customer,
        this.restaurant,
        this.orderItems,
        this.orderStatus,
        this.assignedAgent,
        this.isAgentAssigned,
        this.subtotal,
        this.orderTime});

  ActiveOrderModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    if (json['orderItems'] != null) {
      orderItems = <OrderItems>[];
      json['orderItems'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    orderStatus = json['orderStatus'];
    assignedAgent = json['assignedAgent'] != null
        ? new AssignedAgent.fromJson(json['assignedAgent'])
        : null;
    isAgentAssigned = json['isAgentAssigned'];
    subtotal = json['subtotal'];
    orderTime = json['orderTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    data['orderStatus'] = this.orderStatus;
    if (this.assignedAgent != null) {
      data['assignedAgent'] = this.assignedAgent!.toJson();
    }
    data['isAgentAssigned'] = this.isAgentAssigned;
    data['subtotal'] = this.subtotal;
    data['orderTime'] = this.orderTime;
    return data;
  }
}

class Customer {
  String? sId;
  String? name;
  String? email;
  String? phone;

  Customer({this.sId, this.name, this.email, this.phone});

  Customer.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class Restaurant {
  String? id;
  String? name;
  Address? address;

  Restaurant({this.id, this.name, this.address});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Address {
  String? street;
  String? city;
  String? state;
  String? zip;

  Address({this.street, this.city, this.state, this.zip});

  Address.fromJson(Map<String, dynamic> json) {
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    return data;
  }
}

class OrderItems {
  String? productId;
  int? quantity;
  int? price;
  String? name;
  String? sId;

  OrderItems({this.productId, this.quantity, this.price, this.name, this.sId});

  OrderItems.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    quantity = json['quantity'];
    price = json['price'];
    name = json['name'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['name'] = this.name;
    data['_id'] = this.sId;
    return data;
  }
}

class AssignedAgent {
  String? id;
  String? fullName;
  String? phoneNumber;

  AssignedAgent({this.id, this.fullName, this.phoneNumber});

  AssignedAgent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
