import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthNotifier extends StateNotifier<User?> {
  
  AuthNotifier() : super(FirebaseAuth.instance.currentUser) {
    FirebaseAuth.instance.authStateChanges().listen((user){
      state = user;
    });
  }

  Future<void> login(UserCredential userCredential ) async { 
    state = userCredential.user;
  }

  Future<void> logout() async{ 
    FirebaseAuth.instance.signOut();
    state=null;
  }

 
  
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});
