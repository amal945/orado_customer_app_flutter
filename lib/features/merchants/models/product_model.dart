class ProductModel {
  ProductModel({this.product, this.distance});

  ProductModel.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
    distance = json['Distance'];
  }
  Product? product;
  double? distance;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['Distance'] = distance;
    return data;
  }
}

class Product {
  Product(
      {this.productName,
      this.quantity = 0,
      this.sku,
      this.status,
      this.priorityOrder,
      this.addedAt,
      this.price,
      this.categoryId,
      this.discountId,
      this.costPrice,
      this.subCategoryId,
      this.isAvailable,
      this.description,
      this.isVeg,
      this.longDescription,
      this.preparationTime,
      this.minimumQuantity,
      this.merchantId,
      this.productId,
      this.maximumQuantity,
      this.productstablerelation8,
      this.productstablerelation1});

  Product.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    quantity = 0;
    sku = json['sku'];
    status = json['status'];
    priorityOrder = json['priorityOrder'];
    addedAt = json['addedAt'];
    price = double.parse(json['price'].toString());
    categoryId = json['categoryId'];
    discountId = json['discountId'];
    costPrice = double.parse(json['costPrice'].toString());
    subCategoryId = json['subCategoryId'];
    isAvailable = json['isAvailable'];
    description = json['description'];
    isVeg = json['isVeg'];
    longDescription = json['longDescription'];
    preparationTime = json['preparationTime'];
    minimumQuantity = json['minimumQuantity'];
    merchantId = json['merchantId'];
    productId = json['productId'];
    maximumQuantity = json['maximumQuantity'];
    if (json['productstablerelation8'] != null) {
      productstablerelation8 = <ProductStableRelation8>[];
      json['productstablerelation8'].forEach((v) {
        productstablerelation8!.add(ProductStableRelation8.fromJson(v));
      });
    }
    productstablerelation1 = json['productstablerelation1'] != null ? Productstablerelation1.fromJson(json['productstablerelation1']) : null;
  }
  String? productName;
  late int quantity;
  String? sku;
  int? status;
  int? priorityOrder;
  String? addedAt;
  double? price;
  int? categoryId;
  int? discountId;
  double? costPrice;
  int? subCategoryId;
  int? isAvailable;
  String? description;
  int? isVeg;
  String? longDescription;
  String? preparationTime;
  int? minimumQuantity;
  int? merchantId;
  int? productId;
  int? maximumQuantity;
  List<ProductStableRelation8>? productstablerelation8;
  Productstablerelation1? productstablerelation1;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productName'] = productName;
    data['sku'] = sku;
    data['status'] = status;
    data['priorityOrder'] = priorityOrder;
    data['addedAt'] = addedAt;
    data['price'] = price;
    data['categoryId'] = categoryId;
    data['discountId'] = discountId;
    data['costPrice'] = costPrice;
    data['subCategoryId'] = subCategoryId;
    data['isAvailable'] = isAvailable;
    data['description'] = description;
    data['isVeg'] = isVeg;
    data['longDescription'] = longDescription;
    data['preparationTime'] = preparationTime;
    data['minimumQuantity'] = minimumQuantity;
    data['merchantId'] = merchantId;
    data['productId'] = productId;
    data['maximumQuantity'] = maximumQuantity;
    // if (productstablerelation8 != null) {
    //   data['productstablerelation8'] = productstablerelation8!.map((v) => v.toJson()).toList();
    // }
    if (productstablerelation1 != null) {
      data['productstablerelation1'] = productstablerelation1!.toJson();
    }
    return data;
  }
}

class Productstablerelation1 {
  Productstablerelation1(
      {this.displayAddress,
      this.closingTime,
      this.shopName,
      this.description,
      this.status,
      this.merchantPoints,
      this.addedAt,
      this.handledByUser,
      this.rating,
      this.shopStatus,
      this.merchantId,
      this.servingRadius,
      this.coverImage,
      this.latitude,
      this.shopEmail,
      this.phoneNumber,
      this.longitude,
      this.address,
      this.openingTime,
      this.merchantImage});

  Productstablerelation1.fromJson(Map<String, dynamic> json) {
    displayAddress = json['displayAddress'];
    closingTime = json['closingTime'];
    shopName = json['shopName'];
    description = json['description'];
    status = json['status'];
    merchantPoints = json['merchantPoints'];
    addedAt = json['addedAt'];
    handledByUser = json['handledByUser'];
    rating = json['rating'];
    shopStatus = json['shopStatus'];
    merchantId = json['merchantId'];
    servingRadius = json['servingRadius'];
    coverImage = json['coverImage'];
    latitude = json['latitude'];
    shopEmail = json['shopEmail'];
    phoneNumber = json['phoneNumber'];
    longitude = json['longitude'];
    address = json['address'];
    openingTime = json['openingTime'];
    merchantImage = json['merchantImage'] != null ? MerchantImage.fromJson(json['merchantImage']) : null;
  }
  String? displayAddress;
  String? closingTime;
  String? shopName;
  String? description;
  int? status;
  int? merchantPoints;
  String? addedAt;
  int? handledByUser;
  double? rating;
  int? shopStatus;
  int? merchantId;
  int? servingRadius;
  int? coverImage;
  String? latitude;
  String? shopEmail;
  String? phoneNumber;
  String? longitude;
  String? address;
  String? openingTime;
  MerchantImage? merchantImage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['displayAddress'] = displayAddress;
    data['closingTime'] = closingTime;
    data['shopName'] = shopName;
    data['description'] = description;
    data['status'] = status;
    data['merchantPoints'] = merchantPoints;
    data['addedAt'] = addedAt;
    data['handledByUser'] = handledByUser;
    data['rating'] = rating;
    data['shopStatus'] = shopStatus;
    data['merchantId'] = merchantId;
    data['servingRadius'] = servingRadius;
    data['coverImage'] = coverImage;
    data['latitude'] = latitude;
    data['shopEmail'] = shopEmail;
    data['phoneNumber'] = phoneNumber;
    data['longitude'] = longitude;
    data['address'] = address;
    data['openingTime'] = openingTime;
    if (merchantImage != null) {
      data['merchantImage'] = merchantImage!.toJson();
    }
    return data;
  }
}

class ProductStableRelation8 {
  ProductStableRelation8({this.productImageId, this.imageId, this.productId, this.imageRelation2});

  ProductStableRelation8.fromJson(Map<String, dynamic> json) {
    productImageId = json['productImageId'];
    imageId = json['imageId'];
    productId = json['productId'];
    imageRelation2 = json['imageRelation2'] != null ? ImageRelation2.fromJson(json['imageRelation2']) : null;
  }
  int? productImageId;
  int? imageId;
  int? productId;
  ImageRelation2? imageRelation2;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productImageId'] = productImageId;
    data['imageId'] = imageId;
    data['productId'] = productId;
    if (imageRelation2 != null) {
      data['imageRelation2'] = imageRelation2!.toJson();
    }
    return data;
  }
}

class ImageRelation2 {
  ImageRelation2({this.imageName, this.uploadedBy, this.imageId, this.imageAlt});

  ImageRelation2.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
    uploadedBy = json['uploadedBy'];
    imageId = json['imageId'];
    imageAlt = json['imageAlt'];
  }
  String? imageName;
  int? uploadedBy;
  int? imageId;
  String? imageAlt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageName'] = imageName;
    data['uploadedBy'] = uploadedBy;
    data['imageId'] = imageId;
    data['imageAlt'] = imageAlt;
    return data;
  }
}

class MerchantImage {
  MerchantImage({this.imageId, this.imageAlt, this.imageName, this.uploadedBy});

  MerchantImage.fromJson(Map<String, dynamic> json) {
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
