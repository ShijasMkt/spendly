import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryTealColor,),
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
                  controller: nameController,
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
                      // _checkLogin();
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
      ),
    );
  }
}
