import 'dart:convert';

import 'package:orado_customer/features/cart/models/coupons_response_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

class CouponServices {
  static Future<CouponResponseModel?> getAllCoupons({required String restaurantId}) async {
    try {
      final token = await LocationProvider.getToken();

      final url = Uri.parse("${Urls.baserUrl}user/promocodes/$restaurantId");

      final response = await http.get(url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = CouponResponseModel.fromJson(json);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
