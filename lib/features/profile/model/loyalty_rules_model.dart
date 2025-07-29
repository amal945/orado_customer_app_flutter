class LoyaltyRulesModel {
  bool? success;
  String? message;
  Rules? data;

  LoyaltyRulesModel({this.success, this.message, this.data});

  LoyaltyRulesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Rules.fromJson(json['data']) : null;
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

class Rules {
  String? sId;
  int? iV;
  String? createdAt;
  int? expiryDurationDays;
  int? maxEarningPoints;
  int? maxRedemptionPercent;
  int? minOrderAmountForEarning;
  int? minOrderAmountForRedemption;
  int? minPointsForRedemption;
  int? pointsPerAmount;
  int? redemptionCriteria;
  String? updatedAt;
  int? valuePerPoint;

  Rules(
      {this.sId,
        this.iV,
        this.createdAt,
        this.expiryDurationDays,
        this.maxEarningPoints,
        this.maxRedemptionPercent,
        this.minOrderAmountForEarning,
        this.minOrderAmountForRedemption,
        this.minPointsForRedemption,
        this.pointsPerAmount,
        this.redemptionCriteria,
        this.updatedAt,
        this.valuePerPoint});

  Rules.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    expiryDurationDays = json['expiryDurationDays'];
    maxEarningPoints = json['maxEarningPoints'];
    maxRedemptionPercent = json['maxRedemptionPercent'];
    minOrderAmountForEarning = json['minOrderAmountForEarning'];
    minOrderAmountForRedemption = json['minOrderAmountForRedemption'];
    minPointsForRedemption = json['minPointsForRedemption'];
    pointsPerAmount = json['pointsPerAmount'];
    redemptionCriteria = json['redemptionCriteria'];
    updatedAt = json['updatedAt'];
    valuePerPoint = json['valuePerPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['expiryDurationDays'] = this.expiryDurationDays;
    data['maxEarningPoints'] = this.maxEarningPoints;
    data['maxRedemptionPercent'] = this.maxRedemptionPercent;
    data['minOrderAmountForEarning'] = this.minOrderAmountForEarning;
    data['minOrderAmountForRedemption'] = this.minOrderAmountForRedemption;
    data['minPointsForRedemption'] = this.minPointsForRedemption;
    data['pointsPerAmount'] = this.pointsPerAmount;
    data['redemptionCriteria'] = this.redemptionCriteria;
    data['updatedAt'] = this.updatedAt;
    data['valuePerPoint'] = this.valuePerPoint;
    return data;
  }
}
