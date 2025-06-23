class CategoryModel {
  String? message;
  String? messageType;
  int? statusCode;
  int? count;
  List<CategoryData>? data;

  CategoryModel(
      {this.message, this.messageType, this.statusCode, this.count, this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
    statusCode = json['statusCode'];
    count = json['count'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
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

class CategoryData {
  int? categoryId;
  String? categoryName;
  String? restaurantId;
  Categoryimagerelation? categoryimagerelation;
  List<Categoryrelation1>? categoryrelation1;

  CategoryData(
      {this.categoryId,
        this.categoryName,
        this.restaurantId,
        this.categoryimagerelation,
        this.categoryrelation1});

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    restaurantId = json['restaurantId'];
    categoryimagerelation = json['categoryimagerelation'] != null
        ? new Categoryimagerelation.fromJson(json['categoryimagerelation'])
        : null;
    if (json['categoryrelation1'] != null) {
      categoryrelation1 = <Categoryrelation1>[];
      json['categoryrelation1'].forEach((v) {
        categoryrelation1!.add(new Categoryrelation1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    data['restaurantId'] = this.restaurantId;
    if (this.categoryimagerelation != null) {
      data['categoryimagerelation'] = this.categoryimagerelation!.toJson();
    }
    if (this.categoryrelation1 != null) {
      data['categoryrelation1'] =
          this.categoryrelation1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categoryimagerelation {
  String? imageName;

  Categoryimagerelation({this.imageName});

  Categoryimagerelation.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageName'] = this.imageName;
    return data;
  }
}

class Categoryrelation1 {
  int? subCategoryId;
  String? subcategoryName;
  String? restaurantId;
  Categoryimagerelation? subcategoryImagerelation;

  Categoryrelation1(
      {this.subCategoryId,
        this.subcategoryName,
        this.restaurantId,
        this.subcategoryImagerelation});

  Categoryrelation1.fromJson(Map<String, dynamic> json) {
    subCategoryId = json['subCategoryId'];
    subcategoryName = json['subcategoryName'];
    restaurantId = json['restaurantId'];
    subcategoryImagerelation = json['subcategoryImagerelation'] != null
        ? new Categoryimagerelation.fromJson(json['subcategoryImagerelation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subCategoryId'] = this.subCategoryId;
    data['subcategoryName'] = this.subcategoryName;
    data['restaurantId'] = this.restaurantId;
    if (this.subcategoryImagerelation != null) {
      data['subcategoryImagerelation'] =
          this.subcategoryImagerelation!.toJson();
    }
    return data;
  }
}
