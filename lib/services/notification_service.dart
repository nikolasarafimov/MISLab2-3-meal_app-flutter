import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../screens/meal_detail_screen.dart';

class NotificationService {
  static Future<void> initialize(
      GlobalKey<NavigatorState> navigatorKey) async {
    final messaging = FirebaseMessaging.instance;

    // Ask for permission (iOS + Android 13+)
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // OPTIONAL: print FCM token to debug console so you can test from Firebase console
    final token = await messaging.getToken();
    debugPrint('FCM token: $token');

    // If the app was opened by tapping a notification when CLOSED (terminated)
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, navigatorKey);
    }

    // When app is in background and user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) => _handleMessage(message, navigatorKey),
    );

    // If you want to handle foreground messages manually, you can listen here.
    // For simple assignment it's fine to rely on system notification in background.
    // FirebaseMessaging.onMessage.listen((message) { ... });
  }

  static Future<void> _handleMessage(
      RemoteMessage message,
      GlobalKey<NavigatorState> navigatorKey,
      ) async {
    // We’ll send a data payload with key "action":"random"
    final action = message.data['action'] as String?;
    if (action == 'random') {
      final api = ApiService();
      final meal = await api.fetchRandomMeal();
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(
            mealId: meal.id,
            preloaded: meal,
          ),
        ),
      );
    }
  }
}