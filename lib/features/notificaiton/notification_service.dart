// services/fcm_token_service.dart

import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:orado_customer/utilities/urls.dart';

import '../location/provider/location_provider.dart';

class FCMTokenService {
  /// Saves the FCM token to backend. Returns true on success.
  static Future<bool> saveFCMToken({required String token}) async {
    try {
      final userToken = await LocationProvider.getToken();
      if (userToken == null || userToken.isEmpty) {
        log('FCMTokenService: missing user auth token.');
        return false;
      }

      final requestBody = jsonEncode({"token": token});

      final uri = Uri.parse('${Urls.baserUrl}user/save-fcm-token');

      final response = await http
          .post(
        uri,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      } else {
        log(
            'Failed to save FCM token. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e, st) {
      log('Error saving FCM token: $e\n$st');
      return false;
    }
  }
}
