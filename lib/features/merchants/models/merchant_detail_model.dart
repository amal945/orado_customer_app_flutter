class MerchantDetailModel {
  String? latitude;
  String? openingTime;
  int? status;
  int? handledByUser;
  String? addedAt;
  int? merchantId;
  int? shopStatus;
  int? coverImage;
  String? description;
  String? shopEmail;
  String? phoneNumber;
  String? address;
  int? servingRadius;
  String? displayAddress;
  int? merchantPoints;
  String? longitude;
  String? shopName;
  int? rating;
  String? closingTime;
  MerchantTableRelation1? merchantTableRelation1;
  List<Merchantbanner>? merchantbanner;
  Bannergallery? merchantImage;
  List<Merchanttablerelation4>? merchanttablerelation4;

  MerchantDetailModel(
      {this.latitude,
      this.openingTime,
      this.status,
      this.handledByUser,
      this.addedAt,
      this.merchantId,
      this.shopStatus,
      this.coverImage,
      this.description,
      this.shopEmail,
      this.phoneNumber,
      this.address,
      this.servingRadius,
      this.displayAddress,
      this.merchantPoints,
      this.longitude,
      this.shopName,
      this.rating,
      this.closingTime,
      this.merchantTableRelation1,
      this.merchantbanner,
      this.merchantImage,
      this.merchanttablerelation4});

  MerchantDetailModel.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    openingTime = json['openingTime'];
    status = json['status'];
    handledByUser = json['handledByUser'];
    addedAt = json['addedAt'];
    merchantId = json['merchantId'];
    shopStatus = json['shopStatus'];
    coverImage = json['coverImage'];
    description = json['description'];
    shopEmail = json['shopEmail'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    servingRadius = json['servingRadius'];
    displayAddress = json['displayAddress'];
    merchantPoints = json['merchantPoints'];
    longitude = json['longitude'];
    shopName = json['shopName'];
    rating = json['rating'];
    closingTime = json['closingTime'];
    merchantTableRelation1 = json['merchantTableRelation1'] != null ? MerchantTableRelation1.fromJson(json['merchantTableRelation1']) : null;
    if (json['merchantbanner'] != null) {
      merchantbanner = <Merchantbanner>[];
      json['merchantbanner'].forEach((v) {
        merchantbanner!.add(Merchantbanner.fromJson(v));
      });
    }
    merchantImage = json['merchantImage'] != null ? Bannergallery.fromJson(json['merchantImage']) : null;
    if (json['merchanttablerelation4'] != null) {
      merchanttablerelation4 = <Merchanttablerelation4>[];
      json['merchanttablerelation4'].forEach((v) {
        merchanttablerelation4!.add(Merchanttablerelation4.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['openingTime'] = openingTime;
    data['status'] = status;
    data['handledByUser'] = handledByUser;
    data['addedAt'] = addedAt;
    data['merchantId'] = merchantId;
    data['shopStatus'] = shopStatus;
    data['coverImage'] = coverImage;
    data['description'] = description;
    data['shopEmail'] = shopEmail;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['servingRadius'] = servingRadius;
    data['displayAddress'] = displayAddress;
    data['merchantPoints'] = merchantPoints;
    data['longitude'] = longitude;
    data['shopName'] = shopName;
    data['rating'] = rating;
    data['closingTime'] = closingTime;
    if (merchantTableRelation1 != null) {
      data['merchantTableRelation1'] = merchantTableRelation1!.toJson();
    }
    if (merchantbanner != null) {
      data['merchantbanner'] = merchantbanner!.map((v) => v.toJson()).toList();
    }
    if (merchantImage != null) {
      data['merchantImage'] = merchantImage!.toJson();
    }
    if (merchanttablerelation4 != null) {
      data['merchanttablerelation4'] = merchanttablerelation4!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MerchantTableRelation1 {
  String? userName;
  String? userEmail;
  String? userPhone;
  int? userType;
  String? password;
  int? userId;
  int? status;
  String? addedAt;
  // List<Null>? userrelation3;

  MerchantTableRelation1({this.userName, this.userEmail, this.userPhone, this.userType, this.password, this.userId, this.status, this.addedAt});

  MerchantTableRelation1.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPhone = json['userPhone'];
    userType = json['userType'];
    password = json['password'];
    userId = json['userId'];
    status = json['status'];
    addedAt = json['addedAt'];
    // if (json['userrelation3'] != null) {
    //   userrelation3 = <Null>[];
    //   json['userrelation3'].forEach((v) {
    //     userrelation3!.add(Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['userPhone'] = userPhone;
    data['userType'] = userType;
    data['password'] = password;
    data['userId'] = userId;
    data['status'] = status;
    data['addedAt'] = addedAt;
    // if (userrelation3 != null) {
    //   data['userrelation3'] = userrelation3!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Merchantbanner {
  String? bannervalidity;
  int? bannerid;
  String? bannername;
  int? merchantId;
  int? choosefile;
  int? addToHome;
  int? status;
  Bannergallery? bannergallery;

  Merchantbanner({this.bannervalidity, this.bannerid, this.bannername, this.merchantId, this.choosefile, this.addToHome, this.status, this.bannergallery});

  Merchantbanner.fromJson(Map<String, dynamic> json) {
    bannervalidity = json['bannervalidity'];
    bannerid = json['bannerid'];
    bannername = json['bannername'];
    merchantId = json['merchantId'];
    choosefile = json['choosefile'];
    addToHome = json['addToHome'];
    status = json['status'];
    bannergallery = json['bannergallery'] != null ? Bannergallery.fromJson(json['bannergallery']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bannervalidity'] = bannervalidity;
    data['bannerid'] = bannerid;
    data['bannername'] = bannername;
    data['merchantId'] = merchantId;
    data['choosefile'] = choosefile;
    data['addToHome'] = addToHome;
    data['status'] = status;
    if (bannergallery != null) {
      data['bannergallery'] = bannergallery!.toJson();
    }
    return data;
  }
}

class Bannergallery {
  int? imageId;
  String? imageAlt;
  String? imageName;
  int? uploadedBy;

  Bannergallery({this.imageId, this.imageAlt, this.imageName, this.uploadedBy});

  Bannergallery.fromJson(Map<String, dynamic> json) {
    imageId = json['imageId'];
    imageAlt = json['imageAlt'];
    imageName = json['imageName'];
    uploadedBy = json['uploadedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageId'] = imageId;
    data['imageAlt'] = imageAlt;
    data['imageName'] = imageName;
    data['uploadedBy'] = uploadedBy;
    return data;
  }
}

class Merchanttablerelation4 {
  int? costPrice;
  int? status;
  String? description;
  int? isVeg;
  String? longDescription;
  String? preparationTime;
  int? minimumQuantity;
  int? merchantId;
  int? productId;
  int? maximumQuantity;
  String? productName;
  String? sku;
  String? addedAt;
  int? priorityOrder;
  Null discountId;
  int? price;
  int? categoryId;
  int? subCategoryId;
  List<Productstablerelation8>? productstablerelation8;

  Merchanttablerelation4(
      {this.costPrice,
      this.status,
      this.description,
      this.isVeg,
      this.longDescription,
      this.preparationTime,
      this.minimumQuantity,
      this.merchantId,
      this.productId,
      this.maximumQuantity,
      this.productName,
      this.sku,
      this.addedAt,
      this.priorityOrder,
      this.discountId,
      this.price,
      this.categoryId,
      this.subCategoryId,
      this.productstablerelation8});

  Merchanttablerelation4.fromJson(Map<String, dynamic> json) {
    costPrice = json['costPrice'];
    status = json['status'];
    description = json['description'];
    isVeg = json['isVeg'];
    longDescription = json['longDescription'];
    preparationTime = json['preparationTime'];
    minimumQuantity = json['minimumQuantity'];
    merchantId = json['merchantId'];
    productId = json['productId'];
    maximumQuantity = json['maximumQuantity'];
    productName = json['productName'];
    sku = json['sku'];
    addedAt = json['addedAt'];
    priorityOrder = json['priorityOrder'];
    discountId = json['discountId'];
    price = json['price'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    if (json['productstablerelation8'] != null) {
      productstablerelation8 = <Productstablerelation8>[];
      json['productstablerelation8'].forEach((v) {
        productstablerelation8!.add(Productstablerelation8.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['costPrice'] = costPrice;
    data['status'] = status;
    data['description'] = description;
    data['isVeg'] = isVeg;
    data['longDescription'] = longDescription;
    data['preparationTime'] = preparationTime;
    data['minimumQuantity'] = minimumQuantity;
    data['merchantId'] = merchantId;
    data['productId'] = productId;
    data['maximumQuantity'] = maximumQuantity;
    data['productName'] = productName;
    data['sku'] = sku;
    data['addedAt'] = addedAt;
    data['priorityOrder'] = priorityOrder;
    data['discountId'] = discountId;
    data['price'] = price;
    data['categoryId'] = categoryId;
    data['subCategoryId'] = subCategoryId;
    if (productstablerelation8 != null) {
      data['productstablerelation8'] = productstablerelation8!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productstablerelation8 {
  int? productId;
  int? imageId;
  int? productImageId;
  Bannergallery? imageRelation2;

  Productstablerelation8({this.productId, this.imageId, this.productImageId, this.imageRelation2});

  Productstablerelation8.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    imageId = json['imageId'];
    productImageId = json['productImageId'];
    imageRelation2 = json['imageRelation2'] != null ? Bannergallery.fromJson(json['imageRelation2']) : null;
  }

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
