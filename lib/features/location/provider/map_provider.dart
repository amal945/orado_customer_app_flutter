import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orado_customer/features/location/presentation/address_screen.dart';
import 'package:orado_customer/features/location/provider/address_provider.dart';
import 'package:orado_customer/services/address_services.dart';
import 'package:orado_customer/utilities/utilities.dart';
import 'package:provider/provider.dart';

class MapScreenProvider extends ChangeNotifier {
  // List of tag options for the address
  final List<String> tags = ['Home', 'Work', 'Friends and Family', 'Other'];

  // Currently selected tag
  String _selectedTag = 'Home';

  String get selectedTag => _selectedTag;

  bool get isHomeSelected => _selectedTag == 'Home';

  void selectTag(String tag) {
    if (_selectedTag != tag) {
      _selectedTag = tag;
      notifyListeners();
    }
  }

  final formKey = GlobalKey<FormState>();
  // Address fields
  final TextEditingController houseController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController directionController = TextEditingController();

  // Receiver information
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();

  // Clears all input fields
  void clearFields() {
    houseController.clear();
    areaController.clear();
    directionController.clear();
    receiverNameController.clear();
    receiverPhoneController.clear();
  }

  Future<void> addAddress(BuildContext context, LatLng latlng) async {
    if (houseController.text.trim().isEmpty ||
        areaController.text.trim().isEmpty) {
      showSnackBar(context,
          message: "Please fil mandatory fields", backgroundColor: Colors.red);
      return;
    }

    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final currentLocationAddress =
          '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      final selectedType =
          selectedTag == "Friends and Family" ? "FriendAndFamily" : selectedTag;
      final requestBody = {
        "type": selectedType,
        "receiverName": receiverNameController.text.trim(),
        "receiverPhone": receiverPhoneController.text.trim(),
        "area": areaController.text.trim(),
        "directionsToReach": directionController.text.trim(),
        "displayName": houseController.text.trim(),
        "street": place.street,
        "city": place.locality,
        "state": place.administrativeArea,
        "zip": place.postalCode,
        "longitude": latlng.longitude,
        "latitude": latlng.latitude
      };

      final response =
          await AddressServices.addAddress(requestBody: requestBody);

      if (response.messageType != null && response.messageType == "success") {
        // context.read<AddressProvider>().getAllAddress();
        context.goNamed(AddressScreen.route);
        showSnackBar(context,
            message: response.message!, backgroundColor: Colors.green);
      }
      clearFields();
    } else {
      showSnackBar(context,
          message: "Failed to fetch Address", backgroundColor: Colors.red);
    }
  }
}
