class SignupModel {
  String? message;
  String? messageType;
  String? userId;

  SignupModel({
    this.message,
    this.messageType,
    this.userId,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      message: json['message'] as String,
      messageType: json['messageType'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'messageType': messageType,
      'userId': userId,
    };
  }
}
