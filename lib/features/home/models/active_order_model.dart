class ActiveOrderModel {
  String? sId;
  Customer? customer;
  Restaurant? restaurant;
  List<OrderItem>? orderItems;
  String? orderStatus;
  AssignedAgent? assignedAgent;
  int? isAgentAssigned;
  int? subtotal;
  DateTime? orderTime;
  Location? deliveryLocation;

  ActiveOrderModel({
    this.sId,
    this.customer,
    this.restaurant,
    this.orderItems,
    this.orderStatus,
    this.assignedAgent,
    this.isAgentAssigned,
    this.subtotal,
    this.orderTime,
    this.deliveryLocation,
  });

  factory ActiveOrderModel.fromJson(Map<String, dynamic> json) {
    return ActiveOrderModel(
      sId: json['_id'] as String?,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>)
          : null,
      orderItems: (json['orderItems'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderStatus: json['orderStatus'] as String?,
      assignedAgent: json['assignedAgent'] != null
          ? AssignedAgent.fromJson(json['assignedAgent'] as Map<String, dynamic>)
          : null,
      isAgentAssigned: json['isAgentAssigned'] is int
          ? json['isAgentAssigned'] as int
          : int.tryParse(json['isAgentAssigned']?.toString() ?? ''),
      subtotal: json['subtotal'] is int
          ? json['subtotal'] as int
          : int.tryParse(json['subtotal']?.toString() ?? ''),
      orderTime: json['orderTime'] != null
          ? DateTime.tryParse(json['orderTime'] as String)
          : null,
      deliveryLocation: json['deliveryLocation'] != null
          ? Location.fromJson(json['deliveryLocation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = sId;
    if (customer != null) data['customer'] = customer!.toJson();
    if (restaurant != null) data['restaurant'] = restaurant!.toJson();
    if (orderItems != null) {
      data['orderItems'] = orderItems!.map((e) => e.toJson()).toList();
    }
    data['orderStatus'] = orderStatus;
    if (assignedAgent != null) data['assignedAgent'] = assignedAgent!.toJson();
    data['isAgentAssigned'] = isAgentAssigned;
    data['subtotal'] = subtotal;
    if (orderTime != null) data['orderTime'] = orderTime!.toIso8601String();
    if (deliveryLocation != null) {
      data['deliveryLocation'] = deliveryLocation!.toJson();
    }
    return data;
  }
}

class Customer {
  String? sId;
  String? name;
  String? email;
  String? phone;

  Customer({this.sId, this.name, this.email, this.phone});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      sId: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

class Restaurant {
  String? id;
  String? name;
  String? image;
  Address? address;
  Location? location;

  Restaurant({this.id, this.name, this.image, this.address, this.location});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      address: json['address'] != null
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    if (address != null) data['address'] = address!.toJson();
    if (location != null) data['location'] = location!.toJson();
    return data;
  }
}

class Address {
  String? street;
  String? city;
  String? state;
  String? zip;

  Address({this.street, this.city, this.state, this.zip});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zip: json['zip'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
    };
  }
}

class Location {
  // stored as string to accommodate int/double/string from backend
  String? latitude;
  String? longitude;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
    );
  }

  double? get latitudeAsDouble => latitude != null ? double.tryParse(latitude!) : null;
  double? get longitudeAsDouble => longitude != null ? double.tryParse(longitude!) : null;

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class OrderItem {
  String? productId;
  int? quantity;
  int? price;
  String? name;
  String? sId;
  int? totalPrice;
  String? image;

  OrderItem({
    this.productId,
    this.quantity,
    this.price,
    this.name,
    this.sId,
    this.totalPrice,
    this.image,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] as String?,
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity']?.toString() ?? ''),
      price: json['price'] is int
          ? json['price'] as int
          : int.tryParse(json['price']?.toString() ?? ''),
      name: json['name'] as String?,
      sId: json['_id'] as String?,
      totalPrice: json['totalPrice'] is int
          ? json['totalPrice'] as int
          : int.tryParse(json['totalPrice']?.toString() ?? ''),
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'name': name,
      '_id': sId,
      'totalPrice': totalPrice,
      'image': image,
    };
  }
}

class AssignedAgent {
  String? id;
  String? fullName;
  String? phoneNumber;

  AssignedAgent({this.id, this.fullName, this.phoneNumber});

  factory AssignedAgent.fromJson(Map<String, dynamic> json) {
    return AssignedAgent(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    };
  }
}
