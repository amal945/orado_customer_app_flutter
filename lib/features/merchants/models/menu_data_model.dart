class MenuDataModel {
  final String message;
  final String messageType;
  final MenuData data;

  MenuDataModel({
    required this.message,
    required this.messageType,
    required this.data,
  });

  factory MenuDataModel.fromJson(Map<String, dynamic> json) {
    return MenuDataModel(
      message: json['message'],
      messageType: json['messageType'],
      data: MenuData.fromJson(json['data']),
    );
  }
}

class MenuData {
  final int totalCategories;
  final int categoryPage;
  final int totalCategoryPages;
  final List<Category> menu;

  MenuData({
    required this.totalCategories,
    required this.categoryPage,
    required this.totalCategoryPages,
    required this.menu,
  });

  factory MenuData.fromJson(Map<String, dynamic> json) {
    return MenuData(
      totalCategories: json['totalCategories'],
      categoryPage: json['categoryPage'],
      totalCategoryPages: json['totalCategoryPages'],
      menu: (json['menu'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
    );
  }
}

class Category {
  final String categoryId;
  final String categoryName;
  final String description;
  final List<String> images;
  final int totalProducts;
  final List<MenuItem> items;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.description,
    required this.images,
    required this.totalProducts,
    required this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      description: json['description'],
      images: List<String>.from(json['images']),
      totalProducts: json['totalProducts'],
      items: (json['items'] as List)
          .map((item) => MenuItem.fromJson(item))
          .toList(),
    );
  }
}

class MenuItem {
  final SpecialOffer specialOffer;
  final List<dynamic> attributes;
  final String id;
  final String name;
  final String description;
  final int price;
  final String categoryId;
  final String restaurantId;
  final List<String> images;
  final bool active;
  final int preparationTime;
  final String foodType;
  final List<dynamic> addOns;
  final double rating;
  final String unit;
  final int stock;
  final int reorderLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  MenuItem({
    required this.specialOffer,
    required this.attributes,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.restaurantId,
    required this.images,
    required this.active,
    required this.preparationTime,
    required this.foodType,
    required this.addOns,
    required this.rating,
    required this.unit,
    required this.stock,
    required this.reorderLevel,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      specialOffer: SpecialOffer.fromJson(json['specialOffer']),
      attributes: json['attributes'],
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      categoryId: json['categoryId'],
      restaurantId: json['restaurantId'],
      images: List<String>.from(json['images']),
      active: json['active'],
      preparationTime: json['preparationTime'],
      foodType: json['foodType'],
      addOns: json['addOns'],
      rating: (json['rating'] as num).toDouble(),
      unit: json['unit'],
      stock: json['stock'],
      reorderLevel: json['reorderLevel'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}

class SpecialOffer {
  final int discount;

  SpecialOffer({required this.discount});

  factory SpecialOffer.fromJson(Map<String, dynamic> json) {
    return SpecialOffer(discount: json['discount']);
  }
}
