class ReOrderResponseModel {
  String? success;
  String? messageType;
  String? message;
  Data? data;

  ReOrderResponseModel(
      {this.success, this.messageType, this.message, this.data});

  ReOrderResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    messageType = json['messageType'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['messageType'] = this.messageType;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? cartId;
  String? restaurantId;
  int? totalItems;
  int? totalPrice;

  Data({this.cartId, this.restaurantId, this.totalItems, this.totalPrice});

  Data.fromJson(Map<String, dynamic> json) {
    cartId = json['cartId'];
    restaurantId = json['restaurantId'];
    totalItems = json['totalItems'];
    totalPrice = json['totalPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartId'] = this.cartId;
    data['restaurantId'] = this.restaurantId;
    data['totalItems'] = this.totalItems;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}
