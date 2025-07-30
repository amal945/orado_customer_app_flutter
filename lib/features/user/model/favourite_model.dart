class FavouriteListResponse {
  final String? message;
  final String? messageType;
  final List<FavouriteItem> data;

  FavouriteListResponse({
    this.message,
    this.messageType,
    this.data = const [],
  });

  factory FavouriteListResponse.fromJson(Map<String, dynamic> json) {
    return FavouriteListResponse(
      message: json['message'] as String?,
      messageType: json['messageType'] as String?,
      data: (json['data'] as List<dynamic>?)
              ?.map((v) => FavouriteItem.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'messageType': messageType,
        'data': data.map((v) => v.toJson()).toList(),
      };
}

class FavouriteItem {
  final String? id;
  final String? name;
  final List<String>? images;
  final int? rating;
  final String? outOfDeliveryArea;
  final String? isOpen;

  FavouriteItem({
    this.id,
    this.name,
    this.images = const [],
    this.rating,
    this.outOfDeliveryArea,
    this.isOpen,
  });

  factory FavouriteItem.fromJson(Map<String, dynamic> json) {
    return FavouriteItem(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          [],
      rating: json['rating'] as int?,
      outOfDeliveryArea: json['outOfDeliveryArea'] as String?,
      isOpen: json['isOpen'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'images': images,
    'rating': rating,
    'outOfDeliveryArea': outOfDeliveryArea,
    'isOpen': isOpen,
  };
}
