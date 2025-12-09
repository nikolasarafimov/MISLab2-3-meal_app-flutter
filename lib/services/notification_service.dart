import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../screens/meal_detail_screen.dart';

class NotificationService {
  static Future<void> initialize(
      GlobalKey<NavigatorState> navigatorKey) async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final token = await messaging.getToken();
    debugPrint('FCM token: $token');

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage, navigatorKey);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) => _handleMessage(message, navigatorKey),
    );
  }

  static Future<void> _handleMessage(
      RemoteMessage message,
      GlobalKey<NavigatorState> navigatorKey,
      ) async {
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