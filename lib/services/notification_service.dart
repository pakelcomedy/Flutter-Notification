import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Initialize FCM and local notifications
  Future<void> initializeFCM() async {
    // Initialize local notifications
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // add an icon in assets
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Request permission for notifications (important for iOS)
    await _firebaseMessaging.requestPermission();

    // Get FCM token for device
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");

    // Setup listeners for foreground, background, and app launch
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotification(message);
    });

    // Use instance access for getInitialMessage
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotification(initialMessage);
    }
  }

  // Handle incoming notification
  Future<void> _handleNotification(RemoteMessage message) async {
    // Show a local notification
    var androidDetails = AndroidNotificationDetails(
      'task_manager_channel', 'Task Manager Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformDetails = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(
      0, 
      message.notification?.title, 
      message.notification?.body,
      platformDetails,
      payload: message.data.toString(),
    );

    // Save notification to local storage (Hive)
    _saveNotificationToLocalStorage(message);
  }

  // Save notification to local storage using Hive
  void _saveNotificationToLocalStorage(RemoteMessage message) {
    var notification = {
      'title': message.notification?.title ?? 'No Title',
      'body': message.notification?.body ?? 'No Body',
      'timestamp': DateTime.now().toIso8601String(),
    };
    var box = Hive.box('notifications');
    box.add(notification);
  }
}