class PlaceOrderResponseModel {
  final String? message;
  final String? orderId;
  final double? totalAmount;
  final BillSummary? billSummary;
  final String? orderStatus;
  final String? agentAssignmentStatus;
  final String? messageType;

  PlaceOrderResponseModel({
    this.message,
    this.orderId,
    this.totalAmount,
    this.billSummary,
    this.orderStatus,
    this.agentAssignmentStatus,
    this.messageType,
  });

  factory PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponseModel(
      message: json['message'],
      orderId: json['orderId'],
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      billSummary: json['billSummary'] != null
          ? BillSummary.fromJson(json['billSummary'])
          : null,
      orderStatus: json['orderStatus'],
      agentAssignmentStatus: json['agentAssignmentStatus'],
      messageType: json['messageType'],
    );
  }
}

class BillSummary {
  final double? subtotal;
  final double? discount;
  final double? tax;
  final double? deliveryFee;
  final double? total;
  final double? distanceKm;

  BillSummary({
    this.subtotal,
    this.discount,
    this.tax,
    this.deliveryFee,
    this.total,
    this.distanceKm,
  });

  factory BillSummary.fromJson(Map<String, dynamic> json) {
    return BillSummary(
      subtotal: (json['subtotal'] as num?)?.toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble(),
      total: (json['total'] as num?)?.toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
    );
  }
}
