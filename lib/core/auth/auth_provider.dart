import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false) {
    _loadLoginStatus();
  }

  final Box settingsBox=Hive.box('settingsBox');

  void _loadLoginStatus() {
    final loggedIn = settingsBox.get('isLoggedIn', defaultValue: false) as bool;
    state = loggedIn;
  }

  void login() {
    settingsBox.put('isLoggedIn', true);
    state = true;
  }

  void logout() {
    settingsBox.put('isLoggedIn', false);
    state = false;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});
