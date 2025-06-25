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
  final Location? location;
  final String? id;
  final String? name;
  final List<String> images;
  final int? rating;

  FavouriteItem({
    this.location,
    this.id,
    this.name,
    this.images = const [],
    this.rating,
  });

  factory FavouriteItem.fromJson(Map<String, dynamic> json) {
    return FavouriteItem(
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      id: json['_id'] as String?,
      name: json['name'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rating: json['rating'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'location': location?.toJson(),
        '_id': id,
        'name': name,
        'images': images,
        'rating': rating,
      };
}

class Location {
  final String? type;
  final List<int> coordinates;

  Location({this.type, this.coordinates = const []});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}