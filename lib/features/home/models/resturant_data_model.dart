class RestaurantDataModel {
  String? message;
  String? messageType;
  int? statusCode;
  int? count;
  List<Restaurant>? data;

  RestaurantDataModel(
      {this.message, this.messageType, this.statusCode, this.count, this.data});

  RestaurantDataModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
    statusCode = json['statusCode'];
    count = json['count'];
    if (json['data'] != null) {
      data = <Restaurant>[];
      json['data'].forEach((v) {
        data!.add(new Restaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    data['statusCode'] = this.statusCode;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Restaurant {
  String? shopName;
  String? distance;
  String? deliveryTime;
  String? merchantId;
  String? isMenuAvailable;
  String? isAvailable;
  List<AvailableFoods>? availableFoods;
  Image? image;

  Restaurant(
      {this.shopName,
        this.distance,
        this.deliveryTime,
        this.merchantId,
        this.isMenuAvailable,
        this.isAvailable,
        this.availableFoods,
        this.image});

  Restaurant.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    distance = json['distance'];
    deliveryTime = json['deliveryTime'];
    merchantId = json['merchantId'];
    isMenuAvailable = json['isMenuAvailable'];
    isAvailable = json['isAvailable'];
    if (json['availableFoods'] != null) {
      availableFoods = <AvailableFoods>[];
      json['availableFoods'].forEach((v) {
        availableFoods!.add(new AvailableFoods.fromJson(v));
      });
    }
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shopName'] = this.shopName;
    data['distance'] = this.distance;
    data['deliveryTime'] = this.deliveryTime;
    data['merchantId'] = this.merchantId;
    data['isMenuAvailable'] = this.isMenuAvailable;
    data['isAvailable'] = this.isAvailable;
    if (this.availableFoods != null) {
      data['availableFoods'] =
          this.availableFoods!.map((v) => v.toJson()).toList();
    }
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    return data;
  }
}

class AvailableFoods {
  String? id;
  String? name;
  int? price;
  String? image;
  String? foodType;
  int? discount;

  AvailableFoods(
      {this.id,
        this.name,
        this.price,
        this.image,
        this.foodType,
        this.discount});

  AvailableFoods.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    foodType = json['foodType'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;
    data['foodType'] = this.foodType;
    data['discount'] = this.discount;
    return data;
  }
}

class Image {
  String? imageName;

  Image({this.imageName});

  Image.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageName'] = this.imageName;
    return data;
  }
}
