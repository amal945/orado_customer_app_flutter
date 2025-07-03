import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:orado_customer/features/cart/models/order_summary_model.dart';

class OrderPriceSummaryService {
  final String _baseUrl =
      'https://forforntend-flutter.vercel.app/order/pricesummary';

  Future<OrderPriceSummaryModel?> fetchPriceSummary({
    required String token,
    required String longitude,
    required String latitude,
    required String cartId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "longitude": longitude,
          "latitude": latitude,
          "cartId": cartId,
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
