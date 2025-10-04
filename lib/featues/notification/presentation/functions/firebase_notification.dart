import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spendly/featues/notification/presentation/functions/notification_service.dart';

class FirebaseNotification {
  final msgService = FirebaseMessaging.instance;

  initFCM() async {
    await msgService.requestPermission();

    FirebaseMessaging.onBackgroundMessage(handleNotification);
    FirebaseMessaging.onMessage.listen(handleNotification);
  }
}


Future<void> handleNotification(RemoteMessage  msg) async{
  final title = msg.notification?.title;
  final desc = msg.notification?.body;

  await NotificationService.instance.init();
  await NotificationService.instance.showNotification(title,desc);
}