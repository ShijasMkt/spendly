import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_colors.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.primaryTealColor,iconTheme: IconThemeData(color: Colors.white),),
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
                  controller: nameController,
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
                      // _saveUser();
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
