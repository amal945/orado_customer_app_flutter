class CouponResponseModel {
  List<Coupons>? coupon;

  CouponResponseModel({this.coupon});

  CouponResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['promoCodes'] != null) {
      coupon = <Coupons>[];
      json['promoCodes'].forEach((v) {
        coupon!.add(new Coupons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coupon != null) {
      data['promoCodes'] = this.coupon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coupons {
  String? Id;
  String? code;
  String? discountType;
  int? discountValue;
  int? minOrderValue;
  String? validFrom;
  String? validTill;
  bool? isActive;
  bool? isMerchantSpecific;
  List<String>? applicableMerchants;
  bool? isCustomerSpecific;

  int? maxUsagePerCustomer;
  int? totalUsageCount;

  String? createdAt;
  String? updatedAt;
  int? iV;
  String? description;

  Coupons(
      {this.Id,
      this.code,
      this.discountType,
      this.discountValue,
      this.minOrderValue,
      this.validFrom,
      this.validTill,
      this.isActive,
      this.isMerchantSpecific,
      this.applicableMerchants,
      this.isCustomerSpecific,
      this.maxUsagePerCustomer,
      this.totalUsageCount,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.description});

  Coupons.fromJson(Map<String, dynamic> json) {
    Id = json['_id'];
    code = json['code'];
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    minOrderValue = json['minOrderValue'];
    validFrom = json['validFrom'];
    validTill = json['validTill'];
    isActive = json['isActive'];
    isMerchantSpecific = json['isMerchantSpecific'];
    applicableMerchants = json['applicableMerchants'].cast<String>();
    isCustomerSpecific = json['isCustomerSpecific'];
    maxUsagePerCustomer = json['maxUsagePerCustomer'];
    totalUsageCount = json['totalUsageCount'];

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.Id;
    data['code'] = this.code;
    data['discountType'] = this.discountType;
    data['discountValue'] = this.discountValue;
    data['minOrderValue'] = this.minOrderValue;
    data['validFrom'] = this.validFrom;
    data['validTill'] = this.validTill;
    data['isActive'] = this.isActive;
    data['isMerchantSpecific'] = this.isMerchantSpecific;
    data['applicableMerchants'] = this.applicableMerchants;
    data['isCustomerSpecific'] = this.isCustomerSpecific;
    data['maxUsagePerCustomer'] = this.maxUsagePerCustomer;
    data['totalUsageCount'] = this.totalUsageCount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['description'] = this.description;
    return data;
  }
}
