import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../location/provider/location_provider.dart';
import '../models/live_order_status_update_model.dart';
import '../models/agent_assigned_model.dart';
import '../models/agent_location_model.dart';

class LiveStatusProvider extends ChangeNotifier {
  IO.Socket? _socket;
  bool _isSocketConnected = false;

  Map<String, dynamic> _liveDeliveryStatus = {};
  LiveOrderStatusUpdate? _latestUpdate;
  int _currentStageIndex = 0;

  AgentAssigned? _assignedAgent;
  AgentLocation? _agentLocation;

  Map<String, dynamic> get liveDeliveryStatus => _liveDeliveryStatus;
  LiveOrderStatusUpdate? get latestUpdate => _latestUpdate;
  int get currentStageIndex => _currentStageIndex;
  AgentAssigned? get assignedAgent => _assignedAgent;
  AgentLocation? get agentLocation => _agentLocation;
  bool get isSocketConnected => _isSocketConnected;

  void initSocket({String userType = "user"}) async {
    try {
      final userId = await LocationProvider.getUserId();
      log("🆔 Retrieved userId: $userId");

      if (_socket != null && _socket!.connected) {
        log("ℹ️ Socket already connected, skipping init.");
        return;
      }

      _socket = IO.io(
        'https://orado-backend.onrender.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .build(),
      );

      _socket!.onConnect((_) {
        log("✅ Connected to socket server, socket id: ${_socket!.id}");

        _socket!.emit("join-room", {
          "userId": userId,
          "userType": userType,
        });

        _isSocketConnected = true;
        notifyListeners();
      });

      _socket!.on('order_status_update', (data) {
        log("📦 Delivery update received: $data");

        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          _liveDeliveryStatus = map;
          _latestUpdate = LiveOrderStatusUpdate.fromMap(map);
          _currentStageIndex = _mapStatusToStage(_latestUpdate!.newStatus);
          notifyListeners();
        } else {
          log("⚠️ Received unexpected order_status_update format: $data");
        }
      });

      _socket!.on('agentAssigned', (data) {
        log("👤 agentAssigned event received: $data");
        if (data is Map) {
          try {
            final map = Map<String, dynamic>.from(data);
            log("Parsed map: $map");
            _assignedAgent = AgentAssigned.fromMap(map);
            log("Assigned agent: ${_assignedAgent?.toJson()}");
            notifyListeners();
          } catch (e, st) {
            log("⚠️ Failed to parse agentAssigned payload: $e\n$st");
          }
        } else {
          log("⚠️ Received unexpected agentAssigned format: $data");
        }
      });

      _socket!.on('agentLocationUpdate', (data) {
        log("📍 agentLocationUpdate event received: $data");
        if (data is Map) {
          try {
            final map = Map<String, dynamic>.from(data);
            _agentLocation = AgentLocation.fromMap(map);
            log("Parsed agent location update: ${_agentLocation?.toMap()}");
            notifyListeners();
          } catch (e, st) {
            log("⚠️ Failed to parse agentLocationUpdate payload: $e\n$st");
          }
        } else {
          log("⚠️ Received unexpected agentLocationUpdate format: $data");
        }
      });

      _socket!.onDisconnect((reason) {
        log("⚠️ Socket disconnected, reason: $reason");
        _isSocketConnected = false;
        notifyListeners();
      });

      _socket!.onConnectError((error) {
        log("❌ connect_error: $error");
      });
      _socket!.onError((error) {
        log("❌ general error: $error");
      });
      _socket!.onReconnectAttempt((attempt) {
        log("🔁 Reconnect attempt #$attempt");
      });

      _socket!.connect();
    } catch (e, st) {
      log("🔥 Exception in initSocket: $e\n$st");
    }
  }

  int _mapStatusToStage(String status) {
    switch (status) {
      case 'accepted_by_restaurant':
        return 0;
      case 'preparing':
        return 1;
      case 'ready':
        return 2;
      case 'picked_up':
        return 3;
      case 'on_the_way':
        return 4;
      case 'delivered':
        return 5;
      default:
        return 0;
    }
  }
}
