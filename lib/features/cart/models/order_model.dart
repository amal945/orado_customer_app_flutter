class PlaceOrderResponseModel {
  String? message;
  String? messageType;
  String? orderId;
  String? razorpayOrderId;
  num? amount;
  String? currency;
  String? keyId;

  PlaceOrderResponseModel(
      {this.message,
        this.messageType,
        this.orderId,
        this.razorpayOrderId,
        this.amount,
        this.currency,
        this.keyId});

  PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
    orderId = json['orderId'];
    razorpayOrderId = json['razorpayOrderId'];
    amount = json['amount'];
    currency = json['currency'];
    keyId = json['keyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    data['orderId'] = this.orderId;
    data['razorpayOrderId'] = this.razorpayOrderId;
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['keyId'] = this.keyId;
    return data;
  }
}
