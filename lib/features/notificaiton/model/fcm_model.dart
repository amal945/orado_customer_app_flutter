// controllers/fcm_token_controller.dart

import '../notification_service.dart';

class FCMTokenController {
  final FCMTokenService _fcmTokenService = FCMTokenService();

  Future<bool> saveTokenToServer({
    required String fcmToken,
  }) async {
    // Create the model
    return FCMTokenService.saveFCMToken(token: fcmToken);
  }
}

// models/fcm_token_model.dart

class FCMTokenModel {
  final String userId;
  final String fcmToken;

  FCMTokenModel({required this.userId, required this.fcmToken});

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'token': fcmToken};
  }

  // Create from JSON (useful if your API returns data)
  factory FCMTokenModel.fromJson(Map<String, dynamic> json) {
    return FCMTokenModel(userId: json['userId'], fcmToken: json['token']);
  }
}
