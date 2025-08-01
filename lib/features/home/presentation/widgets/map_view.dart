import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';

class MapView extends StatefulWidget {
  final LatLng restaurantLocation;
  final LatLng deliveryLocation;
  final LatLng? agentLocation;
  final String? mapStyleAsset;
  final void Function(GoogleMapController)? onMapCreatedCallback;

  const MapView({
    super.key,
    required this.restaurantLocation,
    required this.deliveryLocation,
    this.agentLocation,
    this.mapStyleAsset,
    this.onMapCreatedCallback,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  GoogleMapController? _controller;
  LatLng? _displayedAgentLocation; // for animation smoothing
  AnimationController? _agentAnimController;
  Tween<LatLng>? _agentTween;
  Animation<LatLng>? _agentAnimation;

  Timer? _cameraDebounce;

  final MarkerId _restaurantId = const MarkerId('restaurant');
  final MarkerId _deliveryId = const MarkerId('delivery');
  final MarkerId _agentId = const MarkerId('agent');

  @override
  void initState() {
    super.initState();
    _displayedAgentLocation = widget.agentLocation;
    _initAgentAnimation(old: widget.agentLocation, next: widget.agentLocation);
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.agentLocation != null &&
        widget.agentLocation != oldWidget.agentLocation) {
      _animateAgentMovement(from: _displayedAgentLocation, to: widget.agentLocation!);
    }

    // debounce camera update so rapid agent updates don't spam moves
    _scheduleCameraUpdate();
  }

  void _initAgentAnimation({LatLng? old, LatLng? next}) {
    _agentAnimController?.dispose();
    _agentAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    if (old != null && next != null) {
      _agentTween = LatLngTween(begin: old, end: next);
      _agentAnimation = _agentTween!.animate(
        CurvedAnimation(parent: _agentAnimController!, curve: Curves.easeInOut),
      )..addListener(() {
        setState(() {
          _displayedAgentLocation = _agentAnimation!.value;
        });
      });
      _agentAnimController!.forward();
    } else if (next != null) {
      setState(() {
        _displayedAgentLocation = next;
      });
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
        markerId: _restaurantId,
        position: widget.restaurantLocation,
        infoWindow: const InfoWindow(title: 'Restaurant'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: _deliveryId,
        position: widget.deliveryLocation,
        infoWindow: const InfoWindow(title: 'Delivery'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
    if (_displayedAgentLocation != null) {
      markers.add(
        Marker(
          markerId: _agentId,
          position: _displayedAgentLocation!,
          infoWindow: const InfoWindow(title: 'Agent'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        ),
      );
    }
    return markers;
  }

  Polyline _buildRoutePolyline() {
    final points = <LatLng>[
      widget.restaurantLocation,
      if (_displayedAgentLocation != null) _displayedAgentLocation!,
      widget.deliveryLocation,
    ];
    return Polyline(
      polylineId: const PolylineId('route'),
      points: points,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
  }

  LatLngBounds _computeBounds() {
    final latitudes = <double>[
      widget.restaurantLocation.latitude,
      widget.deliveryLocation.latitude,
      if (_displayedAgentLocation != null) _displayedAgentLocation!.latitude,
    ];
    final longitudes = <double>[
      widget.restaurantLocation.longitude,
      widget.deliveryLocation.longitude,
      if (_displayedAgentLocation != null) _displayedAgentLocation!.longitude,
    ];
    final southwest = LatLng(
      latitudes.reduce(min),
      longitudes.reduce(min),
    );
    final northeast = LatLng(
      latitudes.reduce(max),
      longitudes.reduce(max),
    );
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  void _scheduleCameraUpdate() {
    _cameraDebounce?.cancel();
    _cameraDebounce = Timer(const Duration(milliseconds: 300), () {
      if (_controller != null) {
        final bounds = _computeBounds();
        _controller!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80),
        );
      }
    });
  }

  @override
  void dispose() {
    _agentAnimController?.dispose();
    _cameraDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bounds = _computeBounds();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.restaurantLocation,
          zoom: 13,
        ),
        markers: _markers,
        polylines: {_buildRoutePolyline()},
        myLocationEnabled: false,
        myLocationButtonEnabled: false,
        onMapCreated: (controller) async {
          _controller = controller;
          await _applyMapStyle();
          widget.onMapCreatedCallback?.call(controller);
          // initial fit
          await Future.delayed(const Duration(milliseconds: 200));
          try {
            controller.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 80),
            );
          } catch (_) {}
        },
      ),
    );
  }
}

/// Helper to interpolate between LatLngs (since Google Maps doesn't provide one)
class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
      : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    final lat = begin!.latitude + (end!.latitude - begin!.latitude) * t;
    final lng = begin!.longitude + (end!.longitude - begin!.longitude) * t;
    return LatLng(lat, lng);
  }
}
