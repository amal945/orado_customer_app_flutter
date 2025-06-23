class LoginResponseModel {
  String? message;
  String? messageType;
  String? token;
  String? userId;

  LoginResponseModel({this.message, this.messageType, this.token, this.userId});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
    token = json['token'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    data['token'] = this.token;
    data['userId'] = this.userId;
    return data;
  }
}
