class MerchantModel {
  String? shopEmail;
  String? latitude;
  String? phoneNumber;
  String? address;
  String? longitude;
  String? shopName;
  String? displayAddress;
  String? openingTime;
  List<String>? tags; // Updated from String to List<String>
  String? closingTime;
  int? handledByUser;
  String? description;
  int? status;
  int? merchantId;
  int? merchantPoints;
  String? addedAt;
  int? coverImage;
  double? rating;
  int? shopStatus;
  int? servingRadius;
  MerchantImage? merchantImage;

  MerchantModel({
    this.shopEmail,
    this.latitude,
    this.phoneNumber,
    this.address,
    this.longitude,
    this.shopName,
    this.displayAddress,
    this.openingTime,
    this.tags, // Updated
    this.closingTime,
    this.handledByUser,
    this.description,
    this.status,
    this.merchantId,
    this.merchantPoints,
    this.addedAt,
    this.coverImage,
    this.rating,
    this.shopStatus,
    this.servingRadius,
    this.merchantImage,
  });

  // From JSON constructor
  MerchantModel.fromJson(Map<String, dynamic> json) {
    shopEmail = json['shopEmail'];
    latitude = json['latitude'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    longitude = json['longitude'];
    shopName = json['shopName'];
    displayAddress = json['displayAddress'];
    openingTime = json['openingTime'];

    // Handling tags as a List<String>
    if (json['tags'] is String) {
      tags = (json['tags'] as String).split(',').map((tag) => tag.trim()).toList();
    } else if (json['tags'] is List) {
      tags = List<String>.from(json['tags'].map((tag) => tag.toString()));
    } else {
      tags = [];
    }

    closingTime = json['closingTime'];
    handledByUser = json['handledByUser'];
    description = json['description'];
    status = json['status'];
    merchantId = json['merchantId'];
    merchantPoints = json['merchantPoints'];
    addedAt = json['addedAt'];
    coverImage = json['coverImage'];
    rating = json['rating'];
    shopStatus = json['shopStatus'];
    servingRadius = json['servingRadius'];

    // Ensure merchantImage is correctly initialized
    merchantImage = json['merchantImage'] != null ? MerchantImage.fromJson(json['merchantImage']) : null;
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['shopEmail'] = shopEmail;
    data['latitude'] = latitude;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['longitude'] = longitude;
    data['shopName'] = shopName;
    data['displayAddress'] = displayAddress;
    data['openingTime'] = openingTime;

    // Converting tags to JSON array
    data['tags'] = tags != null ? tags!.join(', ') : ''; // Convert List<String> back to String

    data['closingTime'] = closingTime;
    data['handledByUser'] = handledByUser;
    data['description'] = description;
    data['status'] = status;
    data['merchantId'] = merchantId;
    data['merchantPoints'] = merchantPoints;
    data['addedAt'] = addedAt;
    data['coverImage'] = coverImage;
    data['rating'] = rating;
    data['shopStatus'] = shopStatus;
    data['servingRadius'] = servingRadius;

    // Ensure merchantImage is correctly converted to JSON
    if (merchantImage != null) {
      data['merchantImage'] = merchantImage!.toJson();
    }
    return data;
  }
}

class MerchantImage {
  int? imageId;
  String? imageAlt;
  String? imageName;
  int? uploadedBy;

  MerchantImage({this.imageId, this.imageAlt, this.imageName, this.uploadedBy});

  MerchantImage.fromJson(Map<String, dynamic> json) {
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
