import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendly/featues/authentication/presentation/providers/auth_provider.dart';
import 'package:spendly/featues/dashboard/presentation/screens/home_screen.dart';
import 'package:spendly/featues/dashboard/presentation/screens/onboarding_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    if(user == null){
      return const OnboardingScreen();
    }
    else{
      return const HomeScreen();
    }
  }
}
