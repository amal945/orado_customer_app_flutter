import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'model/fcm_model.dart';

class FCMHandler {
  final FCMTokenController _tokenController = FCMTokenController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Initialize FCM and local notifications
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _setupLocalNotifications();
    await _setupFCM();
  }

  Future<void> _setupLocalNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization (updated for newer package versions)
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      // Removed onDidReceiveLocalNotification as it's no longer supported
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        log('Notification tapped: ${response.payload}');
      },
    );
  }

  Future<void> _setupFCM() async {
    // Request permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    // For iOS - get APNS token
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        log('APNS Token: $apnsToken');
      }
    }

    // Get and send FCM token
    await _sendTokenToServer();

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log('FCM Token refreshed: $newToken');
      await _sendTokenToServer();
    });

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('Foreground message: ${message.data}');
      if (message.notification != null) {
        await _showNotification(message);
      }
    });

    // Background and terminated messages
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
      await prefs.setString('fcmToken', token);
      log('FCM token saved to SharedPreferences: $token');

      bool success = await _tokenController.saveTokenToServer(fcmToken: token);
      log(success ? 'Token saved to server successfully' : 'Failed to save token to server');
    } catch (e) {
      log('Error sending token: $e');
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? "Title",
      message.notification?.body ?? "Body",
      notificationDetails,
      payload: message.data.toString(),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Handling a background message: ${message.messageId}");

    // Initialize notifications plugin for background
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? "Title",
      message.notification?.body ?? "Body",
      notificationDetails,
      payload: message.data.toString(),
    );
  }
}