import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/notification_screen.dart';

class Routes {
  static const String home = '/';
  static const String addTask = '/add';
  static const String notifications = '/notifications';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      addTask: (context) => const AddTaskScreen(),
      notifications: (context) => const NotificationScreen(),
    };
  }
}
