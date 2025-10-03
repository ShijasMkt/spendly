import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings, onDidReceiveNotificationResponse: (details){
      debugPrint("Notification tapped : ${details.payload}");
    });
    log("Initialized");
  }

  Future<void> requestNotificationPermission() async{
    if(await Permission.notification.isDenied){
      await Permission.notification.request();
    }
  }

  tz.TZDateTime _next9PM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 12,06);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    log(scheduled.toString());
    return scheduled;
  }

  Future<void> scheduleDailyReminder() async {
    await _plugin.zonedSchedule(
      0,
      'Spendly Reminder',
      'Check your spending overview for today',
      _next9PM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminders',
          channelDescription: 'Daily 9 PM Reminder',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
       
    );
  }

  Future<void> testNotification() async{
    try {
    await _plugin.periodicallyShow(
      1, // Notification ID
      'Test Notification',
      'This will repeat every 1 minute',
      RepeatInterval.everyMinute,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel', // must match the channel you created
          'Test Reminders',
          channelDescription: 'Periodic reminder every 1 minute',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    log("Periodic notification scheduled ✅");
  } catch (e, st) {
    log("Error scheduling periodic notification: $e");
    log("Stacktrace: $st");
  }
  }

  Future<void> showInstantNotification() async {
  await _plugin.show(
    2,
    'Hello',
    'This is an instant notification',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Immediate alerts',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
  );
}


  Future<void> cancelAllNotifications() async{
    await _plugin.cancelAll();
  }
}
