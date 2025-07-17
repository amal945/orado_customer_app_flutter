class MerchantDetailModel {
  final String? messageType;
  final String? message;
  final RestaurantData? data;

  MerchantDetailModel({
    this.messageType,
    this.message,
    this.data,
  });

  factory MerchantDetailModel.fromJson(Map<String, dynamic> json) {
    return MerchantDetailModel(
      messageType: json['messageType'],
      message: json['message'],
      data: json['data'] != null ? RestaurantData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageType': messageType,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class RestaurantData {
  final String? id;
  final String? name;
  final List<String>? images;
  final MerchantAddress? address;
  final MerchantLocation? location;
  final String? phone;
  final String? email;
  final List<dynamic>? offers;
  final bool? active;
  final String? foodType;
  final List<dynamic>? banners;
  final int? rating;
  final int? minOrderAmount;
  final List<String>? paymentMethods;
  final String? image;
  final String? distanceKm;
  final String? estimatedDeliveryTime;

  RestaurantData({
    this.id,
    this.name,
    this.images,
    this.address,
    this.location,
    this.phone,
    this.email,
    this.offers,
    this.active,
    this.foodType,
    this.banners,
    this.rating,
    this.minOrderAmount,
    this.paymentMethods,
    this.image,
    this.distanceKm,
    this.estimatedDeliveryTime,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      id: json['_id'],
      name: json['name'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
      address: json['address'] != null ? MerchantAddress.fromJson(json['address']) : null,
      location: json['location'] != null ? MerchantLocation.fromJson(json['location']) : null,
      phone: json['phone'],
      email: json['email'],
      offers: json['offers'] ?? [],
      active: json['active'],
      foodType: json['foodType'],
      banners: json['banners'] ?? [],
      rating: json['rating'],
      minOrderAmount: json['minOrderAmount'],
      paymentMethods: (json['paymentMethods'] as List?)?.map((e) => e.toString()).toList(),
      image: json['image'],
      distanceKm: json['distanceKm'],
      estimatedDeliveryTime: json['estimatedDeliveryTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'images': images,
      'address': address?.toJson(),
      'location': location?.toJson(),
      'phone': phone,
      'email': email,
      'offers': offers,
      'active': active,
      'foodType': foodType,
      'banners': banners,
      'rating': rating,
      'minOrderAmount': minOrderAmount,
      'paymentMethods': paymentMethods,
      'image': image,
      'distanceKm': distanceKm,
      'estimatedDeliveryTime': estimatedDeliveryTime,
    };
  }
}

class MerchantAddress {
  final String? street;
  final String? city;
  final String? state;
  final String? zip;
  final String? country;

  MerchantAddress({
    this.street,
    this.city,
    this.state,
    this.zip,
    this.country,
  });

  factory MerchantAddress.fromJson(Map<String, dynamic> json) {
    return MerchantAddress(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }
}

class MerchantLocation {
  final String type;
  final List<double> coordinates;

  MerchantLocation({
    required this.type,
    required this.coordinates,
  });

  factory MerchantLocation.fromJson(Map<String, dynamic> json) {
    return MerchantLocation(
      type: json['type'],
      coordinates:
      List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
