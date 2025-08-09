// File: lib/features/home/presentation/widgets/map_view.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// Tween for smoothing agent motion.
class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end}) : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    final lat = begin!.latitude + (end!.latitude - begin!.latitude) * t;
    final lng = begin!.longitude + (end!.longitude - begin!.longitude) * t;
    return LatLng(lat, lng);
  }
}

class MapView extends StatefulWidget {
  final LatLng restaurantLocation;
  final LatLng deliveryLocation;
  final LatLng? agentLocation;
  final String? mapStyleAsset;
  final void Function(GoogleMapController)? onMapCreatedCallback;
  final String googleDirectionsApiKey;
  final double routeUpdateThresholdMeters;

  const MapView({
    super.key,
    required this.restaurantLocation,
    required this.deliveryLocation,
    this.agentLocation,
    this.mapStyleAsset,
    this.onMapCreatedCallback,
    required this.googleDirectionsApiKey,
    this.routeUpdateThresholdMeters = 50,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  GoogleMapController? _controller;
  LatLng? _displayedAgentLocation;
  AnimationController? _agentAnimController;
  Tween<LatLng>? _agentTween;
  Animation<LatLng>? _agentAnimation;

  Timer? _cameraDebounce;
  Timer? _routeDebounce;

  List<LatLng>? _routeRestaurantToAgent;
  List<LatLng>? _routeAgentToDelivery;
  List<LatLng>? _routeRestaurantToDelivery; // used when agentLocation is null

  LatLng? _lastRouteAgentLocation;
  bool _routeFetchFailed = false;

  @override
  void initState() {
    super.initState();
    _displayedAgentLocation = widget.agentLocation;
    _initAgentAnimation(old: widget.agentLocation, next: widget.agentLocation);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshRoutes(force: true);
    });
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.agentLocation != null && widget.agentLocation != oldWidget.agentLocation) {
      _animateAgentMovement(from: _displayedAgentLocation, to: widget.agentLocation!);
      _routeDebounce?.cancel();
      _routeDebounce = Timer(const Duration(milliseconds: 500), () => _refreshRoutes());
    }
    _scheduleCameraUpdate();
  }

  void _initAgentAnimation({LatLng? old, LatLng? next}) {
    _agentAnimController?.dispose();
    _agentAnimController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    if (old != null && next != null) {
      _agentTween = LatLngTween(begin: old, end: next);
      _agentAnimation = _agentTween!.animate(CurvedAnimation(parent: _agentAnimController!, curve: Curves.easeInOut))
        ..addListener(() {
          setState(() {
            _displayedAgentLocation = _agentAnimation!.value;
          });
        });
      _agentAnimController!.forward();
    } else if (next != null) {
      _displayedAgentLocation = next;
    }
  }

  void _animateAgentMovement({LatLng? from, required LatLng to}) {
    final start = from ?? to;
    _initAgentAnimation(old: start, next: to);
  }

  Future<void> _applyMapStyle() async {
    if (widget.mapStyleAsset != null && _controller != null) {
      try {
        final style = await rootBundle.loadString(widget.mapStyleAsset!);
        _controller?.setMapStyle(style);
      } catch (_) {}
    }
  }

  Set<Marker> get _markers {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('restaurant'),
        position: widget.restaurantLocation,
        infoWindow: const InfoWindow(title: 'Restaurant'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: widget.deliveryLocation,
        infoWindow: const InfoWindow(title: 'Delivery'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
    if (_displayedAgentLocation != null) {
      markers.add(Marker(
        markerId: const MarkerId('agent'),
        position: _displayedAgentLocation!,
        infoWindow: const InfoWindow(title: 'Agent'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    }
    return markers;
  }

  Set<Polyline> get _polylines {
    final polylines = <Polyline>{};

    if (widget.agentLocation == null) {
      if (_routeRestaurantToDelivery != null && _routeRestaurantToDelivery!.isNotEmpty) {
        polylines.add(Polyline(
          polylineId: const PolylineId('restaurant_to_delivery'),
          points: _routeRestaurantToDelivery!,
          width: 5,
          color: Colors.blue,
        ));
      }
    } else {
      if (_routeRestaurantToAgent != null && _routeRestaurantToAgent!.isNotEmpty) {
        polylines.add(Polyline(
          polylineId: const PolylineId('restaurant_to_agent'),
          points: _routeRestaurantToAgent!,
          width: 5,
          color: Colors.blue,
        ));
      }
      if (_routeAgentToDelivery != null && _routeAgentToDelivery!.isNotEmpty) {
        polylines.add(Polyline(
          polylineId: const PolylineId('agent_to_delivery'),
          points: _routeAgentToDelivery!,
          width: 5,
          color: Colors.green,
          patterns: [PatternItem.dash(10), PatternItem.gap(5)],
        ));
      }
    }

    if (polylines.isEmpty) {
      // fallback straight line
      final fallbackPoints = <LatLng>[
        widget.restaurantLocation,
        if (_displayedAgentLocation != null) _displayedAgentLocation!,
        widget.deliveryLocation,
      ];
      polylines.add(Polyline(
        polylineId: const PolylineId('fallback_line'),
        points: fallbackPoints,
        width: 5,
        color: Colors.red,
      ));
    }

    return polylines;
  }

  LatLngBounds _computeBounds() {
    final list = <LatLng>[
      widget.restaurantLocation,
      widget.deliveryLocation,
      if (_displayedAgentLocation != null) _displayedAgentLocation!,
      if (_routeRestaurantToDelivery != null) ..._routeRestaurantToDelivery!,
      if (_routeRestaurantToAgent != null) ..._routeRestaurantToAgent!,
      if (_routeAgentToDelivery != null) ..._routeAgentToDelivery!,
    ];
    final latitudes = list.map((p) => p.latitude).toList();
    final longitudes = list.map((p) => p.longitude).toList();
    final southwest = LatLng(latitudes.reduce(min), longitudes.reduce(min));
    final northeast = LatLng(latitudes.reduce(max), longitudes.reduce(max));
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  void _scheduleCameraUpdate() {
    _cameraDebounce?.cancel();
    _cameraDebounce = Timer(const Duration(milliseconds: 300), () {
      if (_controller != null) {
        _controller!.animateCamera(CameraUpdate.newLatLngBounds(_computeBounds(), 80));
      }
    });
  }

  Future<void> _refreshRoutes({bool force = false}) async {
    final agentLoc = _displayedAgentLocation ?? widget.agentLocation;

    if (widget.agentLocation == null) {
      // only restaurant -> delivery
      final route = await _fetchRoute(
        origin: widget.restaurantLocation,
        destination: widget.deliveryLocation,
        apiKey: widget.googleDirectionsApiKey,
      );
      setState(() {
        _routeRestaurantToDelivery = route;
        _routeRestaurantToAgent = null;
        _routeAgentToDelivery = null;
        _routeFetchFailed = route == null;
      });
      return;
    }

    if (agentLoc == null) return;

    if (!force &&
        _lastRouteAgentLocation != null &&
        _distanceBetween(_lastRouteAgentLocation!, agentLoc) < widget.routeUpdateThresholdMeters) {
      return;
    }

    _lastRouteAgentLocation = agentLoc;

    debugPrint('[RouteDebug] restaurant: ${widget.restaurantLocation}');
    debugPrint('[RouteDebug] agent: $agentLoc');
    debugPrint('[RouteDebug] delivery: ${widget.deliveryLocation}');

    final r2a = await _fetchRoute(
      origin: widget.restaurantLocation,
      destination: agentLoc,
      apiKey: widget.googleDirectionsApiKey,
    );
    final a2d = await _fetchRoute(
      origin: agentLoc,
      destination: widget.deliveryLocation,
      apiKey: widget.googleDirectionsApiKey,
    );

    setState(() {
      _routeRestaurantToAgent = r2a;
      _routeAgentToDelivery = a2d;
      _routeRestaurantToDelivery = null;
      _routeFetchFailed = (r2a == null && a2d == null);
    });
  }

  double _distanceBetween(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    final dLat = _toRad(b.latitude - a.latitude);
    final dLon = _toRad(b.longitude - a.longitude);
    final lat1 = _toRad(a.latitude);
    final lat2 = _toRad(b.latitude);
    final h = sin(dLat / 2) * sin(dLat / 2) + cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(h), sqrt(1 - h));
    return earthRadius * c;
  }

  double _toRad(double deg) => deg * pi / 180;

  Future<List<LatLng>?> _fetchRoute({
    required LatLng origin,
    required LatLng destination,
    required String apiKey,
  }) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json'
            '?origin=${origin.latitude},${origin.longitude}'
            '&destination=${destination.latitude},${destination.longitude}'
            '&key=$apiKey&mode=driving',
      );
      debugPrint('[DirectionsAPI] Requesting: $url');

      final resp = await http.get(url);
      debugPrint('[DirectionsAPI] HTTP code: ${resp.statusCode}');
      debugPrint('[DirectionsAPI] Body: ${resp.body}');

      if (resp.statusCode != 200) return null;
      final data = jsonDecode(resp.body);
      if (data['status'] != 'OK') {
        debugPrint('[DirectionsAPI] status: ${data['status']} error_message: ${data['error_message'] ?? 'none'}');
        return null;
      }

      final routes = data['routes'] as List<dynamic>;
      if (routes.isEmpty) return null;

      final overviewPolyline = (routes[0]['overview_polyline']?['points'] ?? '') as String;
      if (overviewPolyline.isEmpty) return null;

      return _decodeEncodedPolyline(overviewPolyline);
    } catch (e, st) {
      debugPrint('[DirectionsAPI] exception: $e\n$st');
      return null;
    }
  }

  List<LatLng> _decodeEncodedPolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int shift = 0, result = 0;
      int b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final deltaLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final deltaLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  @override
  void dispose() {
    _agentAnimController?.dispose();
    _cameraDebounce?.cancel();
    _routeDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bounds = _computeBounds();
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(target: widget.restaurantLocation, zoom: 13),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) async {
              _controller = controller;
              await _applyMapStyle();
              widget.onMapCreatedCallback?.call(controller);
              await Future.delayed(const Duration(milliseconds: 200));
              try {
                controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
              } catch (_) {}
              _refreshRoutes(force: true);
            },
          ),
        ),
        if (_routeFetchFailed)
          Positioned(
            top: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
              child: const Text(
                "Unable to fetch driving route; showing direct line.",
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
