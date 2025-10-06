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

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> saveUser() async {
      setState(() {
        _isLoading = true;
      });
      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        if (mounted) {
          context.mounted
              ? ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("User registered!"),
                  ),
                )
              : null;

          ref.read(authProvider.notifier).login(userCredential);

          context.mounted
              ? AppNavigations().navPushAndRemove(context, HomeScreen())
              : null;
        }
      } on FirebaseAuthException catch (e) {
        context.mounted
            ? ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text("Error: ${e.message}"),
                ),
              )
            : null;
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: _registerAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _registerBody(
              formkey,
              context,
              emailController,
              passwordController,
              saveUser,
            ),
    );
  }

  //appBar
  AppBar _registerAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryTealColor,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }

  //body
  SafeArea _registerBody(
    GlobalKey<FormState> formkey,
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    Future<void> Function() saveUser,
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
                  AppTexts().mainHeading("Let's Personalize Your Journeys"),
                  AppTexts().subHeading("Tell us a bit about yourself")
                ],
              ),

              SizedBox(height: 30),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: emailController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: "Enter a email",
                  hintStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !EmailValidator.validate(value)) {
                    return "Please enter a valid email";
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
                  if (value.length < 6) {
                    return "Please enter minimum 6 characters";
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
                child: Text("Register", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
