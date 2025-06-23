import 'dart:convert';
import 'package:orado_customer/features/home/models/recommended_restaurant_model.dart';
import 'package:orado_customer/features/home/models/resturant_data_model.dart';
import 'package:orado_customer/features/home/models/category_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/services/api_services.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  static Future<CategoryModel> getNearByCategories(
      {required String latitude, required String longitude}) async {
    final token = await LocationProvider.getToken();

    final url = Uri.parse(
        "${Urls.baserUrl}location/nearby-categories?latitude=$latitude&longitude=$longitude");

    final response = await http.get(
      url,
      headers: APIServices.headers,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final data = CategoryModel.fromJson(json);

      return data;
    } else {
      final json = jsonDecode(response.body);

      final data = CategoryModel.fromJson(json);

      return data;
    }
  }

  static Future<RestaurantDataModel> getRestaurants(
      {required String lat, required String long}) async {
    try {
      final token = await LocationProvider.getToken();

      final url = Uri.parse(
          "${Urls.baserUrl}location/nearby-restaurants?latitude=$lat&longitude=$long");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = RestaurantDataModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);

        final data = RestaurantDataModel.fromJson(json);

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<RecommendedRestaurantModel> getRecommendedRestaurant(
      {required String lat, required String long}) async {
    try {
      final url = Uri.parse(
          "${Urls.baserUrl}location/nearby-restaurants/recommended?latitude=$lat&longitude=$long");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = RecommendedRestaurantModel.fromJson(json);
        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = RecommendedRestaurantModel.fromJson(json);
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
