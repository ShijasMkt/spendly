import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/core/auth/auth_provider.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/data/models/user_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/home_screen.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/register.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> checkLogin() async {
      final userBox = Hive.box<User>('users');
      final settingsBox = Hive.box('settingsBox');
      final secureStorage = const FlutterSecureStorage();

      final userName = userNameController.text.trim();
      final enteredPassword = passwordController.text.trim();

      final existingUser = userBox.values
          .cast<User>()
          .where((user) => user.uName == userName)
          .toList();

      if (existingUser.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text("User not found!"),
          ),
        );
      } else {
        final user = existingUser.first;

        final storedPassword = await secureStorage.read(
          key: 'password_${user.id}',
        );
        if (storedPassword == enteredPassword) {
          settingsBox.put('isLoggedIn', true);
          settingsBox.put('currentUser', user.id);
          ref.read(authProvider.notifier).login();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(backgroundColor: Colors.green, content: Text("Welcome!")),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("Enter correct password!"),
            ),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryTealColor),
      body: _loginBody(
        formkey,
        context,
        userNameController,
        passwordController,
        checkLogin,
      ),
    );
  }

  //body
  SafeArea _loginBody(
    GlobalKey<FormState> formkey,
    BuildContext context,
    TextEditingController userNameController,
    TextEditingController passwordController,
    Future<void> Function() checkLogin,
  ) {
    return SafeArea(
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
                    "Welcome Back!",
                    style: TextTheme.of(context).titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Log in to continue your journey",
                    style: TextTheme.of(context).titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              SizedBox(height: 30),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: userNameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Enter your username",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid username";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("New User?", style: TextStyle(fontSize: 14)),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => Register()),
                      );
                    },
                    child: Text(
                      " Register here",
                      style: TextStyle(fontSize: 14, color: Colors.purple),
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                style: AppButtons.mainPinkButton,
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    checkLogin();
                  }
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
