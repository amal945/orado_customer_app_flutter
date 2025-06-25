class ProfileModel {
  bool? success;
  String? message;
  String? messageType;
  Data? data;

  ProfileModel({this.success, this.message, this.messageType, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    messageType = json['messageType'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    data['message'] = message;
    data['messageType'] = messageType;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }

  // Add this for update API
  Map<String, dynamic> toMap() {
    return data?.toMap() ?? {};
  }
}

class Data {
  String? userId;
  String? name;
  String? email;
  String? phone;
  String? userType;
  String? profilePicture;
  String? walletBalance;
  String? loyaltyPoints;
  List<Addresses>? addresses;
  List<String>? deviceTokens;
  String? lastActivity;
  String? createdAt;
  String? updatedAt;

  Data({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.userType,
    this.profilePicture,
    this.walletBalance,
    this.loyaltyPoints,
    this.addresses,
    this.deviceTokens,
    this.lastActivity,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    userType = json['userType'];
    profilePicture = json['profilePicture'];
    walletBalance = json['walletBalance'];
    loyaltyPoints = json['loyaltyPoints'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
    if (json['deviceTokens'] != null) {
      deviceTokens = List<String>.from(json['deviceTokens']);
    }
    lastActivity = json['lastActivity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['userId'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['userType'] = userType;
    data['profilePicture'] = profilePicture;
    data['walletBalance'] = walletBalance;
    data['loyaltyPoints'] = loyaltyPoints;
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    if (deviceTokens != null) {
      data['deviceTokens'] = deviceTokens;
    }
    data['lastActivity'] = lastActivity;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  // For update API
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'profilePicture': profilePicture,
      // Add other fields as needed for update
    };
  }
}

class Addresses {
  String? addressId;
  String? type;
  String? street;
  String? city;
  String? state;
  String? zip;
  Location? location;

  Addresses({
    this.addressId,
    this.type,
    this.street,
    this.city,
    this.state,
    this.zip,
    this.location,
  });

  Addresses.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    type = json['type'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['addressId'] = addressId;
    data['type'] = type;
    data['street'] = street;
    data['city'] = city;
    data['state'] = state;
    data['zip'] = zip;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class Location {
  String? latitude;
  String? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}