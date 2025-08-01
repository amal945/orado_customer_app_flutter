class TicketsModel {
  bool? success;
  String? message;
  List<Ticket>? data;

  TicketsModel({this.success, this.message, this.data});

  TicketsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Ticket>[];
      json['data'].forEach((v) {
        data!.add(new Ticket.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Ticket {
  String? sId;
  String? user;
  String? subject;
  String? message;
  String? status;
  String? priority;
  List<Replies>? replies;
  String? createdAt;
  int? iV;

  Ticket(
      {this.sId,
      this.user,
      this.subject,
      this.message,
      this.status,
      this.priority,
      this.replies,
      this.createdAt,
      this.iV});

  Ticket.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? createdAt;
  String? timestamp;

  Replies(
      {this.sender, this.message, this.sId, this.createdAt, this.timestamp});

  Replies.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    message = json['message'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['message'] = this.message;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
