import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:orado_customer/features/cart/models/order_summary_model.dart';
import 'package:orado_customer/utilities/urls.dart';

class OrderPriceSummaryService {
  Future<OrderPriceSummaryModel?> fetchPriceSummary(
      {required String token,
      required String longitude,
      required String latitude,
      required String cartId,
      String? couponCode,
      String? loyaltyPoints}) async {
    // 76.3019
    //9.9921
    try {
      final response = await http.post(
        Uri.parse("${Urls.baserUrl}order/pricesummary"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "longitude": longitude,
          "latitude": latitude,
          "cartId": cartId,
          if (couponCode != null) "promoCode": couponCode,
          if (loyaltyPoints != null) "loyaltyPointsToRedeem": "20",
          "useLoyaltyPoints": loyaltyPoints != null,
        }),
      );

      if (response.statusCode == 200) {
        return orderPriceSummaryModelFromJson(response.body);
      } else {
        log("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      log("Exception occurred: $e");
      return null;
    }
  }
}
