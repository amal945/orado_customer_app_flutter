import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/merchants/models/menu_data_model.dart';
import 'package:orado_customer/services/api_services.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

import '../features/merchants/models/merchant_detail_model.dart';

class RestaurantServices {
  static Future<MerchantDetailModel> getMerchantDetails(
      {required String restaurantId,required LatLng latlng}) async {
    try {
      final token = await LocationProvider.getToken();


      final url = Uri.parse("${Urls.baserUrl}restaurants/$restaurantId?lat=${latlng.latitude}&lng=${latlng.longitude}");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = MerchantDetailModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = MerchantDetailModel.fromJson(json);

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<MenuDataModel> getRestaurantMenu(
      {required String restaurantId}) async {
    try {
      final url = Uri.parse("${Urls.baserUrl}restaurants/$restaurantId/menu");

      final response = await http.get(url, headers: APIServices.headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = MenuDataModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = MenuDataModel.fromJson(json);

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
