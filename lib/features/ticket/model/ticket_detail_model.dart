class TicketDetailModel {
  bool? success;
  String? message;
  TicketData? data;

  TicketDetailModel({this.success, this.message, this.data});

  TicketDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new TicketData.fromJson(json['data']) : null;
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

class TicketData {
  String? sId;
  String? user;
  String? subject;
  String? message;
  String? status;
  String? priority;
  List<Replies>? replies;
  String? createdAt;
  int? iV;

  TicketData(
      {this.sId,
      this.user,
      this.subject,
      this.message,
      this.status,
      this.priority,
      this.replies,
      this.createdAt,
      this.iV});

  TicketData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    user = json['user'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    priority = json['priority'];
    if (json['replies'] != null) {
      replies = <Replies>[];
      json['replies'].forEach((v) {
        replies!.add(new Replies.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['status'] = this.status;
    data['priority'] = this.priority;
    if (this.replies != null) {
      data['replies'] = this.replies!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Replies {
  String? sender;
  String? message;
  String? createdAt;
  String? sId;

  Replies({this.sender, this.message, this.createdAt, this.sId});

  Replies.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    message = json['message'];
    createdAt = json['createdAt'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['_id'] = this.sId;
    return data;
  }
}
