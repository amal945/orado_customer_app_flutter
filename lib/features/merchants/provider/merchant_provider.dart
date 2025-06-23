import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orado_customer/features/merchants/models/product_model.dart';

import '../../../services/api_services.dart';
import '../models/merchant_detail_model.dart';
import '../models/merchant_model.dart';

class MerchantProvider extends ChangeNotifier {
  final APIServices _apiServices = APIServices();
  bool _isLoading = false;
  String _message = '';

  List<MerchantModel> merchants = [];
  MerchantDetailModel? _singleMerchant;

  Map<String, List<ProductModel>> _merchantProducts = {};
  Map<String, List<ProductModel>> get merchantProducts => _merchantProducts;

  String? selectedMerchantId;
  String _shopStatus = ''; // Added missing _shopStatus for changeShopStatus

  bool get isLoading => _isLoading;
  String get message => _message;
  MerchantDetailModel? get singleMerchant => _singleMerchant;
  String get shopStatus => _shopStatus; // Getter for _shopStatus

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  viewAllProducts(
    BuildContext context, {
    required int limit,
    required int page,
    required double lat,
    required double long,
    String? merchantId,
    String? searchQuery,
    String? categoryId,
    String? subCategoryId,
    String? isVeg,
  }) async {
    putLoading(true);
    var response = await APIServices().viewAllProducts(
      limit: limit,
      page: page,
      searchQuery: searchQuery,
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      merchantId: merchantId,
      isVeg: isVeg,
      lat: lat,
      long: long,
    );
    log('getHome ${response.statusCode}');
    log('getHome ${response.body}');
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      _merchantProducts[merchantId ?? searchQuery ?? categoryId ?? subCategoryId!] = body['detail'].map<ProductModel>((e) => ProductModel.fromJson(e)).toList();
    }
    putLoading(false);
  }
}
