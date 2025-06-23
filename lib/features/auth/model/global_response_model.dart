class GlobalResponseModel {
  String? message;
  String? messageType;


  GlobalResponseModel({this.message, this.messageType, });

  GlobalResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    messageType = json['messageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    return data;
  }
}