class PaymentVerificationModel {
  String? message;
  String? messageType;
  String? orderId;
  String? paymentStatus;
  Allocation? allocation;
  String? nextSteps;

  PaymentVerificationModel(
      {this.message,
        this.messageType,
        this.orderId,
        this.paymentStatus,
        this.allocation,
        this.nextSteps});

  PaymentVerificationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
    orderId = json['orderId'];
    paymentStatus = json['paymentStatus'];
    allocation = json['allocation'] != null
        ? new Allocation.fromJson(json['allocation'])
        : null;
    nextSteps = json['nextSteps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    data['orderId'] = this.orderId;
    data['paymentStatus'] = this.paymentStatus;
    if (this.allocation != null) {
      data['allocation'] = this.allocation!.toJson();
    }
    data['nextSteps'] = this.nextSteps;
    return data;
  }
}

class Allocation {
  String? status;
  Null? agentId;
  Null? agentName;
  String? reason;

  Allocation({this.status, this.agentId, this.agentName, this.reason});

  Allocation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    agentId = json['agentId'];
    agentName = json['agentName'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['agentId'] = this.agentId;
    data['agentName'] = this.agentName;
    data['reason'] = this.reason;
    return data;
  }
}
