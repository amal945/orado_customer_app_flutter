class LoyaltyBalance {
  bool? success;
  String? message;
  Balance? data;

  LoyaltyBalance({this.success, this.message, this.data});

  LoyaltyBalance.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Balance.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Balance {
  int? loyaltyPoints;

  Balance({this.loyaltyPoints});

  Balance.fromJson(Map<String, dynamic> json) {
    loyaltyPoints = json['loyaltyPoints'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loyaltyPoints'] = this.loyaltyPoints;
    return data;
  }
}
