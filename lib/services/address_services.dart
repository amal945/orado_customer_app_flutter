import 'dart:convert';

import 'package:orado_customer/features/auth/model/global_response_model.dart';
import 'package:orado_customer/features/location/models/address_response_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/utilities/urls.dart';
import 'package:http/http.dart' as http;

class AddressServices {
  static Future<AddressReponseModel> getAllAddresses() async {
    try {
      final token = await LocationProvider.getToken();

      final url = Uri.parse("${Urls.baserUrl}user/address");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = AddressReponseModel.fromJson(json);
        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = AddressReponseModel.fromJson(json);
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<GlobalResponseModel> deleteAddress(
      {required String restaurantId}) async {
    try {
      final token = await LocationProvider.getToken();

      final url = Uri.parse("${Urls.baserUrl}user/address/$restaurantId");

      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = GlobalResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = GlobalResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<GlobalResponseModel> addAddress(
      {required Map<String, dynamic> requestBody}) async {
    try {
      final token = await LocationProvider.getToken();

      final url = Uri.parse("${Urls.baserUrl}user/address");

      final response = await http.post(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = GlobalResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = GlobalResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<GlobalResponseModel> updateAddress(
      {required Map<String, dynamic> requestBody,
      required String addressId}) async {
    try {
      final token = await LocationProvider.getToken();
      final url = Uri.parse("${Urls.baserUrl}user/address/$addressId");

      final response = await http.put(
        url,
        body: jsonEncode(requestBody),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final data = GlobalResponseModel.fromJson(json);

        return data;
      } else {
        final json = jsonDecode(response.body);
        final data = GlobalResponseModel.fromJson(json);

        return data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
