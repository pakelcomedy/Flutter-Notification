import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NotificationViewModel extends GetxController {
  // Rx variable to hold the list of notifications
  var notifications = <Map<String, String>>[].obs;

  // Open Hive box before using it
  late Box box;

  @override
  void onInit() {
    super.onInit();
    // Open the 'notifications' box when the ViewModel is initialized
    box = Hive.box('notifications');
    fetchNotifications(); // Fetch notifications when the ViewModel is initialized
  }

  // Fetch notifications from local storage (Hive)
  void fetchNotifications() {
    notifications.value = box.values
        .map((e) => e as Map<String, String>) // Ensure the type is correct
        .toList()
        .reversed
        .toList(); // Show latest notifications first
  }

  // Add a new notification manually (e.g., when fetched from FCM)
  void addNotification(Map<String, String> notification) {
    box.add(notification); // Add notification to the Hive box
    fetchNotifications(); // Refresh the list after adding a new notification
  }

  // Clear all notifications (if needed)
  void clearNotifications() {
    box.clear(); // Clear the box
    fetchNotifications(); // Refresh after clearing
  }
}
