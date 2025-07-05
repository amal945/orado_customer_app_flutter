import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:orado_customer/features/cart/models/order_detail_summary_model.dart';
import 'package:orado_customer/features/cart/models/order_summary_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';

class OrderSummaryService {
  static const String baseUrl = "https://forforntend-flutter.vercel.app/order";

  static Future<OrderSummaryModel?> fetchOrderSummary({
    required String orderId,
  }) async {
    try {
      final token = await LocationProvider.getToken();
      final url = Uri.parse('$baseUrl/$orderId');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return OrderSummaryModel.fromJson(data);
      } else {
        log("Order summary fetch failed: ${response.body}");
        return null;
      }
    } catch (e) {
      log("Exception in fetchOrderSummary: $e");
      return null;
    }
  }
}
