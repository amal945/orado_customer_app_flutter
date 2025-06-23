class HomeModel {
  HomeModel({this.category, this.banner, this.topRestaurants});

  HomeModel.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    if (json['banner'] != null) {
      banner = <Null>[];
      json['banner'].forEach((v) {
        banner!.add(v);
      });
    }
    if (json['topRestaurants'] != null) {
      topRestaurants = <TopRestaurants>[];
      json['topRestaurants'].forEach((v) {
        topRestaurants!.add(TopRestaurants.fromJson(v));
      });
    }
  }
  List<Category>? category;
  List<dynamic>? banner;
  List<TopRestaurants>? topRestaurants;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    if (banner != null) {
      data['banner'] = banner!.map((v) => v.toJson()).toList();
    }
    if (topRestaurants != null) {
      data['topRestaurants'] = topRestaurants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  Category({this.categoryName, this.categoryId, this.categoryImage, this.addedAt, this.status, this.categoryimagerelation, this.categoryrelation1});

  Category.fromJson(Map<String, dynamic> json) {
    categoryName = json['categoryName'];
    categoryId = json['categoryId'];
    categoryImage = json['categoryImage'];
    addedAt = json['addedAt'];
    status = json['status'];
    categoryimagerelation = json['categoryimagerelation'] != null ? Categoryimagerelation.fromJson(json['categoryimagerelation']) : null;
    if (json['categoryrelation1'] != null) {
      categoryrelation1 = <Categoryrelation1>[];
      json['categoryrelation1'].forEach((v) {
        categoryrelation1!.add(Categoryrelation1.fromJson(v));
      });
    }
  }
  String? categoryName;
  int? categoryId;
  int? categoryImage;
  String? addedAt;
  int? status;
  Categoryimagerelation? categoryimagerelation;
  List<Categoryrelation1>? categoryrelation1;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categoryName'] = categoryName;
    data['categoryId'] = categoryId;
    data['categoryImage'] = categoryImage;
    data['addedAt'] = addedAt;
    data['status'] = status;
    if (categoryimagerelation != null) {
      data['categoryimagerelation'] = categoryimagerelation!.toJson();
    }
    if (categoryrelation1 != null) {
      data['categoryrelation1'] = categoryrelation1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categoryimagerelation {
  Categoryimagerelation({this.imageName, this.uploadedBy, this.imageId, this.imageAlt});

  Categoryimagerelation.fromJson(Map<String, dynamic> json) {
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

class Categoryrelation1 {
  Categoryrelation1({this.subcategoryImage, this.status, this.addedAt, this.subCategoryId, this.categoryId, this.subcategoryName, this.subcategoryImagerelation});

  Categoryrelation1.fromJson(Map<String, dynamic> json) {
    subcategoryImage = json['subcategoryImage'];
    status = json['status'];
    addedAt = json['addedAt'];
    subCategoryId = json['subCategoryId'];
    categoryId = json['categoryId'];
    subcategoryName = json['subcategoryName'];
    subcategoryImagerelation = json['subcategoryImagerelation'] != null ? SubcategoryImagerelation.fromJson(json['subcategoryImagerelation']) : null;
  }
  int? subcategoryImage;
  int? status;
  String? addedAt;
  int? subCategoryId;
  int? categoryId;
  String? subcategoryName;
  SubcategoryImagerelation? subcategoryImagerelation;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subcategoryImage'] = subcategoryImage;
    data['status'] = status;
    data['addedAt'] = addedAt;
    data['subCategoryId'] = subCategoryId;
    data['categoryId'] = categoryId;
    data['subcategoryName'] = subcategoryName;
    if (subcategoryImagerelation != null) {
      data['subcategoryImagerelation'] = subcategoryImagerelation!.toJson();
    }
    return data;
  }
}

class SubcategoryImagerelation {
  SubcategoryImagerelation({this.imageName, this.uploadedBy, this.imageId, this.imageAlt});

  SubcategoryImagerelation.fromJson(Map<String, dynamic> json) {
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

class TopRestaurants {
  TopRestaurants({this.shopName, this.distance, this.image, this.merchantId});

  TopRestaurants.fromJson(Map<String, dynamic> json) {
    shopName = json['shopName'];
    distance = json['Distance'];
    image = json['image'] != null ? Categoryimagerelation.fromJson(json['image']) : null;
    merchantId = json['merchantId'].toString();
  }
  String? shopName;
  double? distance;
  Categoryimagerelation? image;
  String? merchantId;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shopName'] = shopName;
    data['Distance'] = distance;
    data['merchantId'] = merchantId;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}
