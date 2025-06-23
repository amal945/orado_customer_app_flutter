import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:orado_customer/features/auth/provider/auth_provider.dart';
import 'package:orado_customer/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class APIServices {
  static const String baseUrl = 'https://orado.zippi360.com'; // development URL

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, dynamic> defaultError = {
    "status": "Failed",
    "message": "An error occured, please try again"
  };

  Future<File> downloadFile(String url) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/${url.split("/").last}');

    await file.writeAsBytes(response.bodyBytes);
    print(
        'File downloaded and saved to ${directory.path}/${url.split("/").last}');
    return file;
  }

  // Auth -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> loginWithPassword(BuildContext context,
      {required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/loginwithpassword');
    var body = jsonEncode({"input": email, "password": password});

    try {


      final response = await http.post(url, headers: headers, body: body);
      log('loginwithpassword ${response.statusCode}');
      return getApiResponse(response);
    } catch (e) {
      print('Error login: $e');
      return defaultError..['message'] = 'Error login: $e';
    }
  }

  Future<Map<String, dynamic>> signUp(BuildContext context,
      {required Map form}) async {
    final url = Uri.parse('$baseUrl/signup');
    var body = jsonEncode(form);

    try {
      final response = await http.post(url, headers: headers, body: body);
      log('signUp ${response.statusCode}');

      return getApiResponse(response);
    } catch (e) {
      print('Error signUp: $e');
      return defaultError..['message'] = 'Error signUp: $e';
    }
  }

  // Home ------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<http.Response> getHome(BuildContext context,
      {required String lat, required String long}) async {
    final url = Uri.parse('$baseUrl/userHome');
    var body = {'latitude': lat, 'longitude': long};
    print(body);

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    checkExpiry(response);
    return response;
  }


  // Merchants ------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<http.Response> viewAllProducts({
    required int limit,
    required int page,
    required double lat,
    required double long,
    String? searchQuery,
    String? categoryId,
    String? subCategoryId,
    String? merchantId,
    String? isVeg,
  }) async {
    final url = Uri.parse('$baseUrl/viewAllProducts');
    var body = {
      'limit': limit.toString(),
      'page': page.toString(),
      'search': searchQuery ?? '',
      'subCategory': subCategoryId ?? '',
      'category': categoryId ?? '',
      'isVeg': isVeg ?? '',
      'merchantId': merchantId ?? '',
      'latitude': lat.toString(),
      'longitude': long.toString(),
    };
    print(body);

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    checkExpiry(response);
    return response;
  }

  // common code for returning api response
  Map<String, dynamic> getApiResponse(http.Response response) {
    try {
      return jsonDecode(response.body);
    } catch (e) {
      log('Error: ${response.statusCode}');
      return defaultError;
    }
  }

  Future<Map<String, dynamic>> reverseGeoCode(
      {required double lat, required double long}) async {
    final url = Uri.parse('$baseUrl/reverse-geocode');
    var body = {'latlng': '$lat,$long'};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    return getApiResponse(response);
  }

  // Cart
  Future<http.Response> getCart(
      {required double lat, required double long}) async {
    final url = Uri.parse('$baseUrl/viewCart');
    var body = {'latitude': lat.toString(), 'longitude': long.toString()};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    checkExpiry(response);
    return response;
  }

  Future<http.Response> addToCart(
      {required String productId,
      required String merchantId,
      required int quantity}) async {
    final url = Uri.parse('$baseUrl/addTocart');
    var body = {
      'productId': productId,
      'quantity': quantity,
      'merchantId': merchantId
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    checkExpiry(response);
    return response;
  }

  Future<http.Response> editCart(
      {required String itemId, required int quantity}) async {
    final url = Uri.parse('$baseUrl/editcart/$itemId');
    var body = {'quantity': quantity};
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    checkExpiry(response);
    return response;
  }

  Future<http.Response> deleteFromCart(String itemId) async {
    final url = Uri.parse('$baseUrl/deleteFromCart/$itemId');
    final response = await http.delete(url, headers: headers);
    checkExpiry(response);
    return response;
  }

  Future<http.Response> buyFromCart(Map body) async {
    final url = Uri.parse('$baseUrl/buyFromCart');
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    checkExpiry(response);
    return response;
  }

  // adasd
  checkExpiry(http.Response response) async {
    if (response.statusCode == 406 || response.statusCode == 401) {
      navigatorKey.currentContext!
          .read<AuthProvider>()
          .logout(navigatorKey.currentContext!);
    }
  }
}
