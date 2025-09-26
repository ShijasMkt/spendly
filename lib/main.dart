import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spendly/featues/authentication/presentation/widgets/auth_gate.dart';
import 'package:spendly/core/constants/app_themes.dart';
import 'package:spendly/featues/category/data/models/category_model.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  await Firebase.initializeApp();
  log("Handling background message: ${message.messageId}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //firebase initialization
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //Hive initialization
  await Hive.initFlutter();
  //Hive adapter registeration
  Hive.registerAdapter((ExpenseAdapter()));
  Hive.registerAdapter(CategoryAdapter());
  //opening hive boxes-
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Category>('categories');
  // final expBox = Hive.box<Expense>('expenses');
  // await expBox.clear();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendly',
      theme: myAppTheme(),
      home: AuthGate(),
    );
  }
}




