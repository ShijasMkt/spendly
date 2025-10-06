import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendly/core/constants/app_texts.dart';
import 'package:spendly/core/utils/app_navigations.dart';
import 'package:spendly/featues/authentication/presentation/providers/auth_provider.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/dashboard/presentation/screens/home_screen.dart';
import 'package:spendly/featues/authentication/presentation/screens/register.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> checkLogin() async {
      setState(() {
        _isLoading = true;
      });
      try {
        final enteredEmail = emailController.text.trim();
        final enteredPassword = passwordController.text.trim();
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: enteredEmail,
              password: enteredPassword,
            );
        if (mounted) {
          ref.read(authProvider.notifier).login(userCredential);
          context.mounted
              ? ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Welcome!"),
                  ),
                )
              : null;
          context.mounted
              ? AppNavigations().navPushAndRemove(context, HomeScreen())
              : null;
        }
      } on FirebaseAuthException catch (e) {
        context.mounted
            ? ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Login Failed ${e.code}"),
                ),
              )
            : null;
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryTealColor),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _loginBody(
              formkey,
              context,
              emailController,
              passwordController,
              checkLogin,
            ),
    );
  }

  //body
  SafeArea _loginBody(
    GlobalKey<FormState> formkey,
    BuildContext context,
    TextEditingController emailController,
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
                  AppTexts().mainHeading("Welcome Back!"),
                  AppTexts().subHeading("Log in to continue your journey")
                ],
              ),

              SizedBox(height: 30),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !EmailValidator.validate(value)) {
                    return "Please enter a valid username";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
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
