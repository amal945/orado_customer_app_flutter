import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orado_customer/features/home/presentation/home_screen.dart';
import 'package:orado_customer/features/location/models/address_response_model.dart';
import 'package:orado_customer/features/location/provider/location_provider.dart';
import 'package:orado_customer/services/address_services.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';

class AddressProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Addresses> addresses = [];

  Future<void> getAllAddress() async {
    toggleLoading();
    try {
      final response = await AddressServices.getAllAddresses();

      print(response?.addresses ?? "Empty");

      if (response != null && response.addresses != null) {
        addresses.clear();
        addresses.addAll(response.addresses ?? []);
        notifyListeners();
      }
    } catch (e) {}

    toggleLoading();
  }

  Future<void> deleteAddress(
      {required BuildContext context, required String restaurantId}) async {
    toggleLoading();
    try {
      final response =
          await AddressServices.deleteAddress(restaurantId: restaurantId);

      if (response.messageType != null && response.messageType == "success") {
        getAllAddress();
        showSnackBar(context,
            message: response.message ?? "Address Deleted Successfully",
            backgroundColor: Colors.green);
      }
    } catch (e) {
      showSnackBar(context, message: "$e", backgroundColor: Colors.red);
    }
    toggleLoading();
  }

  Future<void> setLatLongAddress({
    required BuildContext context,
    required LatLng latlng,
    required String address,
    required String addressId,
  }) async {
    toggleLoading();
    await context.read<LocationProvider>().setLatLongAndAddress(
        latitude: latlng.latitude,
        longitude: latlng.longitude,
        address: address,
        addressId: addressId);
    toggleLoading();
    context.goNamed(Home.route);
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }
}
