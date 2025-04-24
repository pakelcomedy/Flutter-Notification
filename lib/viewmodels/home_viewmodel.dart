import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/task_model.dart';

class HomeViewModel extends ChangeNotifier {
  final List<Task> _tasks = [];
  String? _deviceToken;                // ◀ keep token in a field
  String? get deviceToken => _deviceToken;

  List<Task> get tasks => List.unmodifiable(_tasks);

  HomeViewModel() {
    _initFCM();
  }

  void addTask(Task task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void toggleCompleted(Task task, bool? checked) {
    task.isCompleted = checked ?? false;
    notifyListeners();
  }

  Future<void> _initFCM() async {
    debugPrint('[HomeVM] >> Initializing FCM...');
    try {
      final messaging = FirebaseMessaging.instance;

      // 1) Request permission (iOS)
      final settings = await messaging.requestPermission(
        alert: true, badge: true, sound: true,
      );
      debugPrint('[HomeVM] Permission: ${settings.authorizationStatus}');

      // 2) Get the initial token
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await messaging.getToken();
        _updateDeviceToken(token);
      } else {
        debugPrint('[HomeVM] ⚠️ Permission not granted');
      }

      // 3) Listen for token refreshes
      FirebaseMessaging.instance.onTokenRefresh.listen(_updateDeviceToken);
    } catch (e) {
      debugPrint('[HomeVM] ❌ FCM init error: $e');
    }
  }

  // common handling when a token arrives or refreshes
  Future<void> _updateDeviceToken(String? token) async {
    if (token == null) return;
    _deviceToken = token;
    debugPrint('[HomeVM] 🎫 Device Token: $token');
    notifyListeners();               // update anyone listening to deviceToken
    await _sendTokenToBackend(token);
  }

  Future<void> _sendTokenToBackend(String token) async {
    const base = 'http://192.168.1.21:8000';
    final apiUrl = '$base/api/device-token';
    final payload = {
      'device_token': token,
      'device_type': Platform.isAndroid ? 'android' : 'ios',
    };

    debugPrint('[HomeVM] POST $apiUrl');
    debugPrint('[HomeVM] Payload: ${jsonEncode(payload)}');

    try {
      final resp = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );

      debugPrint('[HomeVM] Status: ${resp.statusCode}');
      debugPrint('[HomeVM] Body: ${resp.body}');

      if (resp.statusCode == 201) {
        debugPrint('[HomeVM] ✅ Token stored successfully');
      } else {
        debugPrint('[HomeVM] ❌ Failed to store token');
      }
    } catch (e) {
      debugPrint('[HomeVM] 🚨 HTTP error: $e');
    }
  }
}
