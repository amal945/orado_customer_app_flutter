class RecommendedRestaurantModel {
  String? messageType;
  String? message;
  int? count;
  List<RecommendedRestaurant>? data;

  RecommendedRestaurantModel(
      {this.messageType, this.message, this.count, this.data});

  RecommendedRestaurantModel.fromJson(Map<String, dynamic> json) {
    messageType = json['messageType'];
    message = json['message'];
    count = json['count'];
    if (json['data'] != null) {
      data = <RecommendedRestaurant>[];
      json['data'].forEach((v) {
        data!.add(new RecommendedRestaurant.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageType'] = this.messageType;
    data['message'] = this.message;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecommendedRestaurant {
  String? shopName;
  String? distance;
  String? deliveryTime;
  String? merchantId;
  String? isMenuAvailable;
  String? isAvailable;
  List<AvailableFoods>? availableFoods;
  Image? image;

  RecommendedRestaurant(
      {this.shopName,
        this.distance,
        this.deliveryTime,
        this.merchantId,
        this.isMenuAvailable,
        this.isAvailable,
        this.availableFoods,
        this.image});

  RecommendedRestaurant.fromJson(Map<String, dynamic> json) {
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
