import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/task.dart';
import 'notified_page.dart';

class NotifyHelper {
  Future<void> initializeNotification() async {
    // Initialize local timezone before scheduling
    await _configureLocalTimeZone();

    // Initialize Awesome Notifications
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.teal,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
        ),
      ],
      debug: true,
    );

    // Request permission if not already granted
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // Listen to notification taps
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onNotificationAction,
    );
  }

  // Show a basic notification immediately
  Future<void> displayNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Default,
        payload: {'customData': 'Payload here'},
      ),
    );
  }

  // Schedule a notification at a specific hour and minute
  Future<void> scheduledNotification(int hour, int min, Task task) async {
    final scheduledDate = _convertTime(hour, min);

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: task.title,
        body: 'Reminder: ${task.note}',
        notificationLayout: NotificationLayout.Default,
        payload: {
          'customData': '${task.title} - ${task.note}',
        },
      ),
      schedule: NotificationCalendar(
        year: scheduledDate.year,
        month: scheduledDate.month,
        day: scheduledDate.day,
        hour: scheduledDate.hour,
        minute: scheduledDate.minute,
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
        timeZone: tz.local.name, // Use set local timezone
      ),
    );
  }

  // Convert the given hour and minute to a future TZDateTime
  tz.TZDateTime _convertTime(int hour, int min) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  // Configure device timezone (hardcoded or default)
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    const String defaultTimeZone = 'Asia/Karachi'; // or 'UTC'
    tz.setLocalLocation(tz.getLocation(defaultTimeZone));
  }

  // When a notification is clicked
  Future<void> onNotificationAction(ReceivedAction action) async {
    final payload = action.payload ?? {};
    final String labelText = payload['customData'] ?? 'No data';

    Get.dialog(
      AlertDialog(
        title: const Text("Notification Clicked"),
        content: Text("Payload: $labelText"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
              Get.to(() => NotifiedPage(label: labelText)); // Open custom page
            },
            child: const Text("Open"),
          ),
        ],
      ),
    );
  }

  // Generate a unique notification ID
  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
