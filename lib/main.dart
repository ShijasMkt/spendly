import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spendly/core/auth/auth_gate.dart';
import 'package:spendly/core/constants/app_themes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //Hive initialization
  await Hive.initFlutter();
  runApp(const MyApp());
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




