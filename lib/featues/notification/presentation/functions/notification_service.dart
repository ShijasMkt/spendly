import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init({Function()? onNotificationClick }) async {

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings, onDidReceiveNotificationResponse: (NotificationResponse response){
      onNotificationClick?.call();
    });
  }

  Future<void> requestNotificationPermission() async{
    if(await Permission.notification.isDenied){
      await Permission.notification.request();
    }
  }

  Future<void> showNotification(
    String? title,
    String? body,
    {String? payload}
  ) async {
  await _plugin.show(
    2,
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel',
        'Spending Overview',
        importance: Importance.high,
        priority: Priority.high,
      ),
    ),
    payload: payload
  );
}


  Future<void> cancelAllNotifications() async{
    await _plugin.cancelAll();
  }
}