import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/features/profile/model/loyalty_rules_model.dart';
import 'package:orado_customer/services/loyalty_services.dart';

class LoyaltyProvider extends ChangeNotifier {
  Rules? data;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int balance = 0;

  Future<void> getRules() async {
    putLoading(true);
    try {
      final response = await LoyaltyServices.getLoyaltyPointsRules();

      if (response != null) {
        data = response.data;
      }
    } catch (e) {
      log("$e");
    }
    putLoading(false);
  }

  Future<void> fetchBalance() async {
    putLoading(true);
    try {
      balance = await LoyaltyServices.getLoyaltyPointsBalance();
    } catch (e) {
      log("$e");
    }
    putLoading(false);
  }

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
