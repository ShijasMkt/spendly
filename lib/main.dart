import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:spendly/featues/expense/presentation/screens/spending_overview.dart';
import 'package:spendly/featues/notification/presentation/functions/firebase_notification.dart';
import 'package:spendly/featues/notification/presentation/functions/notification_service.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spendly/featues/authentication/presentation/widgets/auth_gate.dart';
import 'package:spendly/core/constants/app_themes.dart';
import 'package:spendly/featues/category/data/models/category_model.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //notification service
  await NotificationService.instance.init(
    onNotificationClick: () {
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) => SpendingOverview()),
      );
    },
  );
  await NotificationService.instance.requestNotificationPermission();
  await FirebaseNotification().initFCM();

  //Hive initialization
  await Hive.initFlutter();

  //Hive adapter registeration
  Hive.registerAdapter((ExpenseAdapter()));
  Hive.registerAdapter(CategoryAdapter());

  //opening hive boxes-
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Category>('categories');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_)=>{
    runApp(ProviderScope(child: const MyApp()))
  });

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spendly',
      theme: myAppTheme(),
      navigatorKey: navigatorKey,
      home: AuthGate(),
    );
  }
}
