import 'package:flutter/material.dart';
import 'package:orado_customer/features/location/models/address_response_model.dart';
import 'package:orado_customer/services/address_services.dart';

class AddressProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Addresses> addresses = [];

  Future<void> getAllAddress() async {
    toggleLoading();
    final response = await AddressServices.getAllAddresses();

    if (response.messageType != null && response.messageType == "success") {
      addresses.clear();
      addresses.addAll(response.addresses ?? []);
    }

    toggleLoading();
  }


  Future<void> deleteAddress()async{



  }



  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
