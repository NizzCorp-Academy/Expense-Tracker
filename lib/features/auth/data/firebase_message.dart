import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessage {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFCM() async {
    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('✅ FCM Token: $token');
    }

    // Save token to SharedPreferences
    if (token != null) {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setString('fcmToken', token);
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📥 [Foreground] ${message.notification?.title}: ${message.notification?.body}');
      }
    });

    // Handle notification when app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('📲 [OpenedApp] ${message.notification?.title}');
      }
    });

    // Handle when app is launched from terminated state via notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null && kDebugMode) {
      print('🔄 [TerminatedOpen] ${initialMessage.notification?.title}');
    }
  }
}
