class MerchantDetailModel {
  final String messageType;
  final String message;
  final RestaurantData data;

  MerchantDetailModel({
    required this.messageType,
    required this.message,
    required this.data,
  });

  factory MerchantDetailModel.fromJson(Map<String, dynamic> json) {
    return MerchantDetailModel(
      messageType: json['messageType'],
      message: json['message'],
      data: RestaurantData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageType': messageType,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class RestaurantData {
  final String id;
  final String name;
  final List<String> images;
  final MerchantAddress address;
  final MerchantLocation location;
  final String phone;
  final String email;
  final List<dynamic> offers;
  final bool active;
  final String foodType;
  final List<dynamic> banners;
  final int rating;
  final int minOrderAmount;
  final List<String> paymentMethods;
  final String image;
  final String distanceKm;
  final String estimatedDeliveryTime;

  RestaurantData({
    required this.id,
    required this.name,
    required this.images,
    required this.address,
    required this.location,
    required this.phone,
    required this.email,
    required this.offers,
    required this.active,
    required this.foodType,
    required this.banners,
    required this.rating,
    required this.minOrderAmount,
    required this.paymentMethods,
    required this.image,
    required this.distanceKm,
    required this.estimatedDeliveryTime,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      id: json['_id'],
      name: json['name'],
      images: List<String>.from(json['images']),
      address: MerchantAddress.fromJson(json['address']),
      location: MerchantLocation.fromJson(json['location']),
      phone: json['phone'],
      email: json['email'],
      offers: List<dynamic>.from(json['offers']),
      active: json['active'],
      foodType: json['foodType'],
      banners: List<dynamic>.from(json['banners']),
      rating: json['rating'],
      minOrderAmount: json['minOrderAmount'],
      paymentMethods: List<String>.from(json['paymentMethods']),
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
      'address': address.toJson(),
      'location': location.toJson(),
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
  final String street;
  final String city;
  final String state;
  final String zip;

  MerchantAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory MerchantAddress.fromJson(Map<String, dynamic> json) {
    return MerchantAddress(
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
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
      coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
