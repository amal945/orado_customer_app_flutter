import 'dart:convert';

import 'package:orado_customer/features/profile/model/loyalty_balance.dart';
import 'package:orado_customer/features/profile/model/loyalty_rules_model.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

import '../features/location/provider/location_provider.dart';

class LoyaltyServices {
  static Future<LoyaltyRulesModel?> getLoyaltyPointsRules() async {
    try {
      final url = Uri.parse("${Urls.getLoyalty}");

      final response = await http.get(url);

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = LoyaltyRulesModel.fromJson(json);

        return data;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> getLoyaltyPointsBalance() async {
    try {
      final url = Uri.parse("${Urls.getLoyaltyPointsBalance}");

      final token = await LocationProvider.getToken();

      final response = await http.get(url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final data = LoyaltyBalance.fromJson(json);

        return data.data?.loyaltyPoints ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      rethrow;
    }
  }
}
