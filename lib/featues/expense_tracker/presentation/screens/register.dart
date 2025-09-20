import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/core/auth/auth_provider.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/data/models/user_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/home_screen.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController uNameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> saveUser() async {
      final userBox = Hive.box<User>('users');
      final settingsBox = Hive.box('settingsBox');
      final secureStorage = const FlutterSecureStorage();

      final userName = uNameController.text.trim();
      final password = passwordController.text.trim();

      final existingUser = userBox.values
          .cast<User>()
          .where((user) => user.uName == userName)
          .toList();

      if (existingUser.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Username already exists!")));
        return;
      }

      final userID = DateTime.now().microsecondsSinceEpoch.toString();

      final newUser = User(id: userID, uName: userName);

      
      await secureStorage.write(key: 'password_$userID', value: password);
      

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("User registered!"),
        ),
      );
      userBox.put(userID,newUser);

      settingsBox.put('isLoggedIn', true);
      settingsBox.put('currentUser', userID);

      ref.read(authProvider.notifier).login();
      Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
            (route) => false,
          );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryTealColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Text(
                      "Let's Personalize Your Journeys",
                      style: TextTheme.of(context).titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Tell us a bit about yourself",
                      style: TextTheme.of(context).titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(height: 30),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: uNameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "Enter a username",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a valid name";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter a password",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
                Spacer(),
                ElevatedButton(
                  style: AppButtons.mainPinkButton,
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      saveUser();
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
