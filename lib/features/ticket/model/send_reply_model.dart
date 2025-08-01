class SendReplyModel {
  String? message;
  SendTicket? ticket;

  SendReplyModel({this.message, this.ticket});

  SendReplyModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    ticket =
    json['ticket'] != null ? new SendTicket.fromJson(json['ticket']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.ticket != null) {
      data['ticket'] = this.ticket!.toJson();
    }
    return data;
  }
}

class SendTicket {
  String? sId;
  String? user;
  String? subject;
  String? message;
  String? status;
  String? priority;
  List<Replies>? replies;
  String? createdAt;
  int? iV;

  SendTicket(
      {this.sId,
        this.user,
        this.subject,
        this.message,
        this.status,
        this.priority,
        this.replies,
        this.createdAt,
        this.iV});

  SendTicket.fromJson(Map<String, dynamic> json) {
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

  Replies({this.sender, this.message, this.sId, this.createdAt});

  Replies.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    message = json['message'];
    sId = json['_id'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['message'] = this.message;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
