import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:orado_customer/features/home/presentation/widgets/map_view.dart';
import 'package:provider/provider.dart';

import 'package:orado_customer/features/home/models/active_order_model.dart';
import 'package:orado_customer/features/home/provider/live_status_provider.dart';
import 'package:orado_customer/utilities/placeholders.dart';
import 'package:orado_customer/utilities/styles.dart';
import '../../../utilities/colors.dart';

class OrderStageModel {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const OrderStageModel({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}

const List<OrderStageModel> dummyStages = [
  OrderStageModel(
    title: "Order Confirmed",
    subtitle: "Restaurant has accepted your order",
    color: Color(0xFF3B82F6),
    icon: Icons.check_circle,
  ),
  OrderStageModel(
    title: "Being Prepared",
    subtitle: "Your delicious meal is being cooked",
    color: Color(0xFF9F7CFC),
    icon: Icons.restaurant,
  ),
  OrderStageModel(
    title: "Ready for Pickup",
    subtitle: "Food is ready, delivery partner will pick up soon",
    color: Color(0xFF8B5CF6),
    icon: Icons.inventory_2,
  ),
  OrderStageModel(
    title: "Picked Up",
    subtitle: "Delivery partner has picked up your order",
    color: Color(0xFF22C55E),
    icon: Icons.navigation,
  ),
  OrderStageModel(
    title: "Out for Delivery",
    subtitle: "Your order is on the way!",
    color: Color(0xFF10B981),
    icon: Icons.local_shipping,
  ),
  OrderStageModel(
    title: "Delivered",
    subtitle: "Your order has been delivered",
    color: Color(0xFF4ADE80),
    icon: Icons.check,
  ),
];

class LiveStatusScreen extends StatefulWidget {
  final ActiveOrderModel data;

  const LiveStatusScreen({super.key, required this.data});

  static const String route = '/live-status';

  @override
  State<LiveStatusScreen> createState() => _LiveStatusScreenState();
}

class _LiveStatusScreenState extends State<LiveStatusScreen> {
  LatLng? _restaurantLocation;
  LatLng? _deliveryLocation;
  LatLng? _currentAgentLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final liveProvider = context.read<LiveStatusProvider>();
      liveProvider.initSocket();
      _initializeData();
      liveProvider.addListener(_onProviderUpdate);
    });
  }

  void _initializeData() {
    // Try to extract restaurant & delivery locations from the passed-in model
    final restaurantLoc = widget.data.restaurant?.location;
    final deliveryLoc = widget.data.deliveryLocation;

    if (restaurantLoc != null &&
        restaurantLoc.latitudeAsDouble != null &&
        restaurantLoc.longitudeAsDouble != null) {
      _restaurantLocation = LatLng(
        restaurantLoc.latitudeAsDouble!,
        restaurantLoc.longitudeAsDouble!,
      );
    }

    if (deliveryLoc != null &&
        deliveryLoc.latitudeAsDouble != null &&
        deliveryLoc.longitudeAsDouble != null) {
      _deliveryLocation = LatLng(
        deliveryLoc.latitudeAsDouble!,
        deliveryLoc.longitudeAsDouble!,
      );
    }

    // // Fallbacks if any are still null
    // _restaurantLocation ??= const LatLng(12.9716, 77.5946); // Bangalore
    // _deliveryLocation ??= const LatLng(12.9666, 77.6000); // Nearby
  }


  void _onProviderUpdate() {
    final liveProvider = context.read<LiveStatusProvider>();
    final agentLoc = liveProvider.agentLocation;
    if (agentLoc != null) {
      setState(() {
        _currentAgentLocation = LatLng(
          agentLoc.latitude,
          agentLoc.longitude,
        );
      });
    }
  }

  @override
  void dispose() {
    context.read<LiveStatusProvider>().removeListener(_onProviderUpdate);
    super.dispose();
  }

  Widget _buildStageTile(int index, {required bool completed}) {
    final stage = dummyStages[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
              completed ? stage.color.withOpacity(0.2) : Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(
              stage.icon,
              color: completed ? stage.color : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: completed ? Colors.black : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stage.subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatusText(LiveStatusProvider provider) {
    final update = provider.latestUpdate;
    if (update == null) return "Fetching status...";
    switch (update.newStatus) {
      case 'accepted_by_restaurant':
        return "Order Confirmed";
      case 'preparing':
        return "Being Prepared";
      case 'ready':
        return "Ready for Pickup";
      case 'picked_up':
        return "Picked Up";
      case 'on_the_way':
        return "Out for Delivery";
      case 'delivered':
        return "Delivered";
      default:
        return update.newStatus.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _timeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return "just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    return "${diff.inDays} d ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Live Order Status",
            style:
            AppStyles.getBoldTextStyle(fontSize: 14, color: Colors.white),
          ),
          backgroundColor: AppColors.baseColor,
          foregroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Consumer<LiveStatusProvider>(builder: (context, liveProvider, _) {
          final stageIndex = liveProvider.currentStageIndex;
          final agent = liveProvider.assignedAgent;

          final agentName =
              agent?.fullName ?? "Delivery agent hasn't been assigned";
          final subtitle = agent != null
              ? "Call: ${agent.phoneNumber}"
              : "Waiting for assignment";
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 300,
                  child: _restaurantLocation == null ||
                      _deliveryLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : MapView(
                    restaurantLocation: _restaurantLocation!,
                    deliveryLocation: _deliveryLocation!,
                    agentLocation: _currentAgentLocation,
                    mapStyleAsset: 'assets/map_style.json',
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatStatusText(liveProvider),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "ON TIME",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                if (liveProvider.latestUpdate != null)
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Updated ${_timeAgo(liveProvider.latestUpdate!.timestamp)}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade300,
                        child: agent != null
                            ? Image.network(PlaceHolders.deliveryAgentIcon)
                            : const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agent != null
                                  ? "$agentName is on the way to deliver your order"
                                  : agentName,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12,
                                color: agent != null
                                    ? Colors.black54
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (agent != null)
                        IconButton(
                          onPressed: () {
                            // TODO: implement call using agent.phoneNumber
                          },
                          icon: const Icon(Icons.call, color: Colors.orange),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(
                      dummyStages.length,
                          (i) => _buildStageTile(i, completed: i <= stageIndex),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        }));
  }
}
