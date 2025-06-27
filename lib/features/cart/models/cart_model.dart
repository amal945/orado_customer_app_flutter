class CartModel {
  String? message;
  String? messageType;
  Data? data;

  CartModel({this.message, this.messageType, this.data});

  CartModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? cartId;
  String? userId;
  String? restaurantId;
  List<Products>? products;
  int? totalPrice;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.cartId,
        this.userId,
        this.restaurantId,
        this.products,
        this.totalPrice,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    userId = json['userId'];
    restaurantId = json['restaurantId'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartId'] = this.cartId;
    data['userId'] = this.userId;
    data['restaurantId'] = this.restaurantId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = this.totalPrice;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Products {
  String? productId;
  String? name;
  String? description;
  List<String>? images;
  String? foodType;
  int? price;
  int? quantity;
  int? total;

  Products({
    this.productId,
    this.name,
    this.description,
    this.images,
    this.foodType,
    this.price,
    this.quantity,
    this.total,
  });

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    foodType = json['foodType'];
    price = json['price'];
    quantity = json['quantity'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = this.productId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['images'] = this.images;
    data['foodType'] = this.foodType;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    return data;
  }

  Products copyWith({
    String? productId,
    String? name,
    String? description,
    List<String>? images,
    String? foodType,
    int? price,
    int? quantity,
    int? total,
  }) {
    return Products(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      foodType: foodType ?? this.foodType,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      total: total ?? this.total,
    );
  }
}

