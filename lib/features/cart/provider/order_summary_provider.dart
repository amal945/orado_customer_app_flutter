import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:orado_customer/features/cart/models/order_detail_summary_model.dart';
import 'package:orado_customer/services/order_summary.dart';

class OrderSummaryController extends ChangeNotifier {
  static Future<OrderSummaryModel?> getOrderSummary({
    required BuildContext context,
    required String orderId,
  }) async {
    final response = await OrderSummaryService.fetchOrderSummary(
      orderId: orderId,
    );

    if (response != null && response.messageType == "success") {
      log("Order Summary fetched for orderId: $orderId");
      return response;
    } else {
      log("Failed to fetch Order Summary.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Failed to fetch order details."),
            backgroundColor: Colors.red),
      );
      return null;
    }
  }
}
