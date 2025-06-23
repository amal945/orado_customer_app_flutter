import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  // Collects all the form data into a map
  Map<String, dynamic> collectAddressData({double? lat, double? lng}) {
    return {
      'lat': lat,
      'lng': lng,
      'house': houseController.text,
      'area': areaController.text,
      'directions': directionController.text,
      'receiverName': receiverNameController.text,
      'receiverPhone': receiverPhoneController.text,
      'tag': _selectedTag,
    };
  }

  Future<void> addAddress(BuildContext context, LatLng latlng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latlng.latitude, latlng.longitude);
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      final currentLocationAddress = '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }

    final selectedType = selectedTag == "Friends and Family" ? "FriendAndFamily" : selectedTag;
    final requestBody = {
      "type": selectedType,
      "receiverName": receiverNameController.text.trim(),
      "receiverPhone": receiverPhoneController.text.trim(),
      "area": "flatnoe 2",
      "directionsToReach": "nerat hte e",
      "displayName": "Alpha Fitness Club",
      "street": "15, 5th Main, HSR Layout",
      "city": "Bangalore",
      "state": "Karnataka",
      "zip": "560102",
      "longitude": "77.6418",
      "latitude": "12.9141"
    };
  }
}
