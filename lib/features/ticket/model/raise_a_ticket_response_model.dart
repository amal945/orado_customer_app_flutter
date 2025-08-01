class RaiseATicketResponseModel {
  bool? success;
  String? message;
  RaisedTicket? data;

  RaiseATicketResponseModel({this.success, this.message, this.data});

  RaiseATicketResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? new RaisedTicket.fromJson(json['data']) : null;
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

class RaisedTicket {
  String? user;
  String? subject;
  String? message;
  String? status;
  String? priority;

  String? sId;
  String? createdAt;
  int? iV;

  RaisedTicket(
      {this.user,
      this.subject,
      this.message,
      this.status,
      this.priority,
      this.sId,
      this.createdAt,
      this.iV});

  RaisedTicket.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    priority = json['priority'];

    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['status'] = this.status;
    data['priority'] = this.priority;

    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
