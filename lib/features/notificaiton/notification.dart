import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/fcm_model.dart';

class FCMHandler {
  final FCMTokenController _tokenController = FCMTokenController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Initialize FCM, local notifications, and TTS
  Future<void> initialize() async {
    await Firebase.initializeApp();

    _setupLocalNotifications();
    await _setupFCM();
  }

  void _setupLocalNotifications() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _setupFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    await _sendTokenToServer();

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log('FCM Token refreshed: $newToken');
      await _sendTokenToServer();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Foreground message: ${message.data}');
      if (message.notification != null) {
        _showNotification(message);
        final String spokenText =
            message.notification?.title ?? "New notification received";
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  }

  Future<void> _sendTokenToServer() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token == null) {
        log('FCM token is null');
        return;
      }

      final prefs = await SharedPreferences.getInstance();

      // 🔐 Save token to SharedPreferences
      await prefs.setString('fcmToken', token);
      log('FCM token saved to SharedPreferences: $token');

      // Send to server via controller
      bool success = await _tokenController.saveTokenToServer(
        fcmToken: token,
      );

      if (success) {
        log('Token saved to server successfully');
      } else {
        log('Failed to save token to server');
      }
    } catch (e) {
      log('Error sending token: $e');
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? "Title",
      message.notification?.body ?? "Body",
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseBackgroundMessageHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");
  }
}
