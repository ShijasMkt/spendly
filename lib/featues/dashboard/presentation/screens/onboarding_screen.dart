import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_images.dart';
import 'package:spendly/featues/authentication/presentation/screens/login.dart';
import 'package:spendly/featues/authentication/presentation/screens/register.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _onBoardingBody(context));
  }

  //body
  SafeArea _onBoardingBody(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AppImages.appBackground,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text('Welcome to Spendly', style: TextTheme.of(context).titleLarge),
            Text(
              'Take control of your money with ease. Track your spending, build better habits, and make smarter financial decisions every day.',
              style: TextTheme.of(context).titleSmall,
              textAlign: TextAlign.center,
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Register()),
                );
              },
              style: AppButtons.mainPinkButton,
              child: Text('Get Started'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a member?',
                  style: TextTheme.of(context).titleSmall,
                ),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Login()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
