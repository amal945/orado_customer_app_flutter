import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utilities/utilities.dart';

class LocationProvider extends ChangeNotifier {
  bool _isloading = false;

  bool get isloading => _isloading;

  late PermissionStatus _permissionGranted;
  late bool _serviceEnabled;
  bool _isRequestingLocation = false;

  LatLng? currentLocationLatLng;
  String? currentLocationAddress;

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  putLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  Future<void> setLatLongAndAddress(
      {required double latitude,
      required double longitude,
      String? address}) async {
    currentLocationLatLng = LatLng(latitude, longitude);
    if (address == null) {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        currentLocationAddress =
            '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    }else{
      currentLocationAddress = address;
    }
  }

  static Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("token");

    return token ?? "";
  }

  static Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("userId");

    return token ?? "";
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    if (_isRequestingLocation) return;
    _isRequestingLocation = true;

    final stopwatch = Stopwatch()..start();

    Location location = Location();
    LocationData? currentLocation;

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          _isRequestingLocation = false;
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          _isRequestingLocation = false;
          return;
        }
      }

      log("Fetching location...");
      currentLocation = await location.getLocation();
      stopwatch.stop();

      log("Location fetch time: ${stopwatch.elapsedMilliseconds} ms");
      log("Got location: ${currentLocation.latitude}, ${currentLocation.longitude}");

      currentLocationLatLng =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
      final lat = currentLocation.latitude!;
      final lng = currentLocation.longitude!;
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        currentLocationAddress =
            '${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      log("Location error: $e");
      currentLocation = null;
    }

    _isRequestingLocation = false;
    notifyListeners();
  }

  FutureOr<void> addMarker(LatLng latLng) async {
    const String markerIdVal = 'Delivery Location';
    const MarkerId markerId = MarkerId(markerIdVal);
    final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    final BitmapDescriptor icon = BitmapDescriptor.bytes(
      await getBytesFromAsset('assets/images/location.png', 25),
    );
    final Marker marker = Marker(
      icon: icon,
      markerId: markerId,
      draggable: true,
      onDrag: (LatLng value) async {},
      position: latLng,
      infoWindow: InfoWindow(
          title: markerIdVal,
          snippet: 'Lat ${latLng.latitude} - Lng ${latLng.longitude}'),
      // onTap: () async {},
    );
    markers[markerId] = marker;
    notifyListeners();
  }
}
