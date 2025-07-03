import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/features/cart/models/order_summary_model.dart';
import 'package:orado_customer/services/price_summary_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPriceSummaryController with ChangeNotifier {
  final OrderPriceSummaryService _service = OrderPriceSummaryService();

  OrderPriceSummaryModel? priceSummary;
  bool isLoading = false;

  Future<void> loadPriceSummary({
    required String longitude,
    required String latitude,
    required String cartId,
  }) async {
    isLoading = true;
    notifyListeners();

    // Retrieve token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Ensure key matches saved token

    if (token == null) {
      log("Token not found in SharedPreferences");
      isLoading = false;
      notifyListeners();
      return;
    }

    final result = await _service.fetchPriceSummary(
      token: token,
      longitude: longitude,
      latitude: latitude,
      cartId: cartId,
    );

    if (result != null) {
      priceSummary = result;
    }

    isLoading = false;
    notifyListeners();
  }
}
