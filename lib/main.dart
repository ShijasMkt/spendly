import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spendly/core/auth/auth_gate.dart';
import 'package:spendly/core/constants/app_themes.dart';
import 'package:spendly/featues/expense_tracker/data/models/category_model.dart';
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';
import 'package:spendly/featues/expense_tracker/data/models/user_model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Hive initialization
  await Hive.initFlutter();
  //Hive adapter registeration
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter((ExpenseAdapter()));
  Hive.registerAdapter(CategoryAdapter());
  //opening hive boxes
  await Hive.openBox('settingsBox');
  await Hive.openBox<User>('users');
  await Hive.openBox<Expense>('expenses');
  await Hive.openBox<Category>('categories');
  // final userBox = Hive.box<User>('Users');
  // await userBox.clear();
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




