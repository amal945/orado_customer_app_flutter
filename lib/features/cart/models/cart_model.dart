class CartModel {
  CartModel({this.cartItems = const <CartItemModel>[], this.totalCost, this.alldata, this.previousAddress});

  CartModel.fromJson(Map<String, dynamic> json) {
    if (json['detail'] != null) {
      cartItems = <CartItemModel>[];
      json['detail'].forEach((v) {
        cartItems!.add(CartItemModel.fromJson(v));
      });
    }
    totalCost = json['totalCost'];
    alldata = json['alldata'] != null ? Alldata.fromJson(json['alldata']) : null;
    if (json['previousAddress'] != null) {
      previousAddress = <Null>[];
      previousAddress = json['previousAddress'];
    }
  }
  List<CartItemModel>? cartItems;
  double? totalCost;
  Alldata? alldata;
  List? previousAddress;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cartItems != null) {
      data['detail'] = cartItems!.map((v) => v.toJson()).toList();
    }
    data['totalCost'] = totalCost;
    if (alldata != null) {
      data['alldata'] = alldata!.toJson();
    }
    if (previousAddress != null) {
      data['previousAddress'] = previousAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartItemModel {
  CartItemModel({this.quantity, this.cartId, this.userId, this.merchantId, this.addedAt, this.productId, this.status, this.cartproductrelation});

  CartItemModel.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    cartId = json['cartId'];
    userId = json['userId'];
    merchantId = json['merchantId'];
    addedAt = json['addedAt'];
    productId = json['productId'];
    status = json['status'];
    cartproductrelation = json['cartproductrelation'] != null ? Cartproductrelation.fromJson(json['cartproductrelation']) : null;
  }
  int? quantity;
  int? cartId;
  int? userId;
  int? merchantId;
  String? addedAt;
  int? productId;
  int? status;
  Cartproductrelation? cartproductrelation;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['cartId'] = cartId;
    data['userId'] = userId;
    data['merchantId'] = merchantId;
    data['addedAt'] = addedAt;
    data['productId'] = productId;
    data['status'] = status;
    if (cartproductrelation != null) {
      data['cartproductrelation'] = cartproductrelation!.toJson();
    }
    return data;
  }
}

class Cartproductrelation {
  Cartproductrelation(
      {this.description,
      this.isVeg,
      this.longDescription,
      this.preparationTime,
      this.minimumQuantity,
      this.merchantId,
      this.productId,
      this.productName,
      this.maximumQuantity,
      this.sku,
      this.status,
      this.price,
      this.priorityOrder,
      this.addedAt,
      this.costPrice,
      this.categoryId,
      this.discountId,
      this.subCategoryId,
      this.isAvailable,
      this.productstablerelation1,
      this.productstablerelation8});

  Cartproductrelation.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    isVeg = json['isVeg'];
    longDescription = json['longDescription'];
    preparationTime = json['preparationTime'];
    minimumQuantity = json['minimumQuantity'];
    merchantId = json['merchantId'];
    productId = json['productId'];
    productName = json['productName'];
    maximumQuantity = json['maximumQuantity'];
    sku = json['sku'];
    status = json['status'];
    price = json['price'];
    priorityOrder = json['priorityOrder'];
    addedAt = json['addedAt'];
    costPrice = json['costPrice'];
    categoryId = json['categoryId'];
    discountId = json['discountId'];
    subCategoryId = json['subCategoryId'];
    isAvailable = json['isAvailable'];
    productstablerelation1 = json['productstablerelation1'] != null ? Productstablerelation1.fromJson(json['productstablerelation1']) : null;
    if (json['productstablerelation8'] != null) {
      productstablerelation8 = <Productstablerelation8>[];
      json['productstablerelation8'].forEach((v) {
        productstablerelation8!.add(Productstablerelation8.fromJson(v));
      });
    }
  }
  String? description;
  int? isVeg;
  String? longDescription;
  String? preparationTime;
  int? minimumQuantity;
  int? merchantId;
  int? productId;
  String? productName;
  int? maximumQuantity;
  String? sku;
  int? status;
  int? price;
  int? priorityOrder;
  String? addedAt;
  int? costPrice;
  int? categoryId;
  Null? discountId;
  int? subCategoryId;
  int? isAvailable;
  Productstablerelation1? productstablerelation1;
  List<Productstablerelation8>? productstablerelation8;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['isVeg'] = isVeg;
    data['longDescription'] = longDescription;
    data['preparationTime'] = preparationTime;
    data['minimumQuantity'] = minimumQuantity;
    data['merchantId'] = merchantId;
    data['productId'] = productId;
    data['productName'] = productName;
    data['maximumQuantity'] = maximumQuantity;
    data['sku'] = sku;
    data['status'] = status;
    data['price'] = price;
    data['priorityOrder'] = priorityOrder;
    data['addedAt'] = addedAt;
    data['costPrice'] = costPrice;
    data['categoryId'] = categoryId;
    data['discountId'] = discountId;
    data['subCategoryId'] = subCategoryId;
    data['isAvailable'] = isAvailable;
    if (productstablerelation1 != null) {
      data['productstablerelation1'] = productstablerelation1!.toJson();
    }
    if (productstablerelation8 != null) {
      data['productstablerelation8'] = productstablerelation8!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productstablerelation1 {
  Productstablerelation1(
      {this.merchantId,
      this.servingRadius,
      this.coverImage,
      this.latitude,
      this.shopEmail,
      this.phoneNumber,
      this.longitude,
      this.address,
      this.openingTime,
      this.shopName,
      this.displayAddress,
      this.closingTime,
      this.description,
      this.status,
      this.handledByUser,
      this.merchantPoints,
      this.addedAt,
      this.rating,
      this.shopStatus});

  Productstablerelation1.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    servingRadius = json['servingRadius'];
    coverImage = json['coverImage'];
    latitude = json['latitude'];
    shopEmail = json['shopEmail'];
    phoneNumber = json['phoneNumber'];
    longitude = json['longitude'];
    address = json['address'];
    openingTime = json['openingTime'];
    shopName = json['shopName'];
    displayAddress = json['displayAddress'];
    closingTime = json['closingTime'];
    description = json['description'];
    status = json['status'];
    handledByUser = json['handledByUser'];
    merchantPoints = json['merchantPoints'];
    addedAt = json['addedAt'];
    rating = json['rating'];
    shopStatus = json['shopStatus'];
  }
  int? merchantId;
  int? servingRadius;
  int? coverImage;
  String? latitude;
  String? shopEmail;
  String? phoneNumber;
  String? longitude;
  String? address;
  String? openingTime;
  String? shopName;
  String? displayAddress;
  String? closingTime;
  String? description;
  int? status;
  int? handledByUser;
  int? merchantPoints;
  String? addedAt;
  double? rating;
  int? shopStatus;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['servingRadius'] = servingRadius;
    data['coverImage'] = coverImage;
    data['latitude'] = latitude;
    data['shopEmail'] = shopEmail;
    data['phoneNumber'] = phoneNumber;
    data['longitude'] = longitude;
    data['address'] = address;
    data['openingTime'] = openingTime;
    data['shopName'] = shopName;
    data['displayAddress'] = displayAddress;
    data['closingTime'] = closingTime;
    data['description'] = description;
    data['status'] = status;
    data['handledByUser'] = handledByUser;
    data['merchantPoints'] = merchantPoints;
    data['addedAt'] = addedAt;
    data['rating'] = rating;
    data['shopStatus'] = shopStatus;
    return data;
  }
}

class Productstablerelation8 {
  Productstablerelation8({this.productId, this.imageId, this.productImageId, this.imageRelation2});

  Productstablerelation8.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    imageId = json['imageId'];
    productImageId = json['productImageId'];
    imageRelation2 = json['imageRelation2'] != null ? ImageRelation2.fromJson(json['imageRelation2']) : null;
  }
  int? productId;
  int? imageId;
  int? productImageId;
  ImageRelation2? imageRelation2;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['imageId'] = imageId;
    data['productImageId'] = productImageId;
    if (imageRelation2 != null) {
      data['imageRelation2'] = imageRelation2!.toJson();
    }
    return data;
  }
}

class ImageRelation2 {
  ImageRelation2({this.imageId, this.imageAlt, this.imageName, this.uploadedBy});

  ImageRelation2.fromJson(Map<String, dynamic> json) {
    imageId = json['imageId'];
    imageAlt = json['imageAlt'];
    imageName = json['imageName'];
    uploadedBy = json['uploadedBy'];
  }
  int? imageId;
  String? imageAlt;
  String? imageName;
  int? uploadedBy;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageId'] = imageId;
    data['imageAlt'] = imageAlt;
    data['imageName'] = imageName;
    data['uploadedBy'] = uploadedBy;
    return data;
  }
}

class Alldata {
  Alldata({this.distance, this.duration, this.deliveryCharge, this.taxes, this.error});

  Alldata.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    duration = json['duration'];
    deliveryCharge = json['deliveryCharge'];
    if (json['taxes'] != null) {
      taxes = <Taxes>[];
      json['taxes'].forEach((v) {
        taxes!.add(Taxes.fromJson(v));
      });
    }
    error = json['error'];
  }
  double? distance;
  double? duration;
  double? deliveryCharge;
  List<Taxes>? taxes;
  String? error;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['duration'] = duration;
    data['deliveryCharge'] = deliveryCharge;
    if (taxes != null) {
      data['taxes'] = taxes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Taxes {
  Taxes({this.tax});

  Taxes.fromJson(Map<String, dynamic> json) {
    if (json['tax'] != null) {
      tax = <Tax>[];
      json['tax'].forEach((v) {
        tax!.add(Tax.fromJson(v));
      });
    }
  }
  List<Tax>? tax;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tax {
  Tax({this.taxName, this.taxAmount});

  Tax.fromJson(Map<String, dynamic> json) {
    taxName = json['taxName'];
    taxAmount = json['taxAmount'];
  }
  String? taxName;
  double? taxAmount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['taxName'] = taxName;
    data['taxAmount'] = taxAmount;
    return data;
  }
}
