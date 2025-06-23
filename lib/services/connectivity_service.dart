import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(true);

  StreamSubscription? _subscription;

  ConnectivityService() {
    _subscription = _connectivity.onConnectivityChanged.listen((status) async {
      final hasInternet = await _checkInternetConnection();
      isConnected.value = hasInternet;
    });
  }

  Future<bool> _checkInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void dispose() {
    _subscription?.cancel();
  }
}

final connectivityService = ConnectivityService();
