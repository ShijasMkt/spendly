import 'package:flutter/material.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/home_screen.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/onboarding_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn =true;
    return isLoggedIn? HomeScreen():OnboardingScreen();
  }
}