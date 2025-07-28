import 'dart:async';
import 'dart:developer';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utilities/utilities.dart';

class LocationProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isloading => _isLoading;

  late PermissionStatus _permissionGranted;
  late bool _serviceEnabled;
  bool _isRequestingLocation = false;

  LatLng? currentLocationLatLng;
  String? currentLocationAddress;
  String? selectedAddressId;

  final Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void putLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> setLatLongAndAddress({
    required double latitude,
    required double longitude,
    String? address,
    String? addressId,
  }) async {
    selectedAddressId = addressId;
    currentLocationLatLng = LatLng(latitude, longitude);

    if (address != null) {
      currentLocationAddress = address;
    } else {
      currentLocationAddress = await _getAddressFromLatLng(latitude, longitude);
    }

    notifyListeners();
  }

  static Future<String> getToken() async => SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("token") ?? "");

  static Future<String> getUserId() async => SharedPreferences.getInstance()
      .then((prefs) => prefs.getString("userId") ?? "");

  Future<void> getCurrentLocation(BuildContext context) async {
    if (_isRequestingLocation) return;
    _isRequestingLocation = true;
    final stopwatch = Stopwatch()..start();
    try {
      log("⏳ Requesting location (Location + Geolocator fallback)");


      final location = Location();

      // Ensure service is enabled
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;

      // Ensure permission is granted
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
      }
      if (_permissionGranted != PermissionStatus.granted) return;

      final locationFuture = location.getLocation().catchError((e) {
        log(" Location package error: $e");
        return null;
      });

      final geoFuture = geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.medium,
      ).catchError((e) {
        log(" Geolocator error: $e");
        return null;
      });

      final result = await Future.any([locationFuture, geoFuture]);

      if (result is LocationData &&
          result.latitude != null &&
          result.longitude != null) {
        log(" Fetched from Location");
        currentLocationLatLng = LatLng(result.latitude!, result.longitude!);
      } else if (result is geo.Position) {
        log(" Fetched from Geolocator");
        currentLocationLatLng = LatLng(result.latitude, result.longitude);
      } else {
        log(" No valid location from either source");
      }

      if (currentLocationLatLng != null) {
        currentLocationAddress = await _getAddressFromLatLng(
          currentLocationLatLng!.latitude,
          currentLocationLatLng!.longitude,
        );
        notifyListeners();
      }
    } catch (e) {
      log("❌ Location fetch failed: $e");
    } finally {
      stopwatch.stop();
      log("⏱️ Location fetch took ${stopwatch.elapsedMilliseconds} ms");
      _isRequestingLocation = false;
    }
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return '${p.name}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}, ${p.country}';
      }
    } catch (e) {
      log("❌ Reverse geocoding failed: $e");
    }
    return "Unknown Location";
  }

  Future<void> addMarker(LatLng latLng) async {
    const String markerIdVal = 'Delivery Location';
    const MarkerId markerId = MarkerId(markerIdVal);
    final BitmapDescriptor icon = BitmapDescriptor.bytes(
      await getBytesFromAsset('assets/images/location.png', 25),
    );

    markers[markerId] = Marker(
      icon: icon,
      markerId: markerId,
      draggable: true,
      position: latLng,
      infoWindow: InfoWindow(
        title: markerIdVal,
        snippet: 'Lat ${latLng.latitude} - Lng ${latLng.longitude}',
      ),
    );

    notifyListeners();
  }
}
