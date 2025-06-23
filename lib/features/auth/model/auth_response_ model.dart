class AuthResponseModel {
  String? message;
  String? messageType;
  String? userId;

  AuthResponseModel({this.message, this.messageType, this.userId});

  AuthResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    data['userId'] = this.userId;
    return data;
  }
}