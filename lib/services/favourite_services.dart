import 'dart:convert';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/features/user/model/favourite_model.dart';
import 'package:orado_customer/services/api_services.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

class FavouriteServices {
  static Future<FavouriteListResponse> getFavourites() async {
    try {
      final token = await LocationProvider.getToken();
      final url = Uri.parse(Urls.getFavourite);
      final response = await http.get(
        url,
        headers: {
          ...APIServices.headers,
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return FavouriteListResponse.fromJson(json);
      } else {
        print('Failed to fetch favourites. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception("Failed to fetch favourites");
      }
    } catch (e) {
      print("Exception in getFavourites: $e");
      rethrow;
    }
  }

  static Future<FavouriteListResponse> addFavourite(
      {required String restaurantId}) async {
    try {
      final token = await LocationProvider.getToken();
      final url = Uri.parse(Urls.addfavourite);
      final response = await http.post(
        url,
        headers: {
          ...APIServices.headers,
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'restaurantId': restaurantId}),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return FavouriteListResponse.fromJson(json);
      } else {
        print('Failed to add favourite. Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return FavouriteListResponse.fromJson(json);
      }
    } catch (e) {
      print("Exception in addFavourite: $e");
      rethrow;
    }
  }

static Future<FavouriteListResponse> removeFavourite({required String restaurantId}) async {
  try {
    final token = await LocationProvider.getToken();
    final url = Uri.parse('${Urls.removeFavourite}/$restaurantId');
    final response = await http.delete(
      url,
      headers: {
        ...APIServices.headers,
        'Authorization': 'Bearer $token',
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 204) {
      return FavouriteListResponse.fromJson(json);
    } else {
      print('Failed to remove favourite. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
      return FavouriteListResponse.fromJson(json);
    }
  } catch (e) {
    print("Exception in removeFavourite: $e");
    rethrow;
  }
}
}
