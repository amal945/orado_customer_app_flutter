class AddressReponseModel {
  bool? success;
  String? message;
  String? messageType;
  List<Addresses>? addresses;

  AddressReponseModel(
      {this.success, this.message, this.messageType, this.addresses});

  AddressReponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    messageType = json['messageType'];
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  String? addressId;
  String? type;
  String? displayName;
  String? street;
  String? area;
  String? city;
  String? state;
  String? zip;
  String? receiverName;
  String? receiverPhone;
  String? directionsToReach;
  String? isDefault;
  Location? location;
  String? addressString;

  Addresses(
      {this.addressId,
        this.type,
        this.displayName,
        this.street,
        this.area,
        this.city,
        this.state,
        this.zip,
        this.receiverName,
        this.receiverPhone,
        this.directionsToReach,
        this.isDefault,
        this.location,
        this.addressString});

  Addresses.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    type = json['type'];
    displayName = json['displayName'];
    street = json['street'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    receiverName = json['receiverName'];
    receiverPhone = json['receiverPhone'];
    directionsToReach = json['directionsToReach'];
    isDefault = json['isDefault'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    addressString = json['addressString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressId'] = this.addressId;
    data['type'] = this.type;
    data['displayName'] = this.displayName;
    data['street'] = this.street;
    data['area'] = this.area;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['receiverName'] = this.receiverName;
    data['receiverPhone'] = this.receiverPhone;
    data['directionsToReach'] = this.directionsToReach;
    data['isDefault'] = this.isDefault;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['addressString'] = this.addressString;
    return data;
  }
}

class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
