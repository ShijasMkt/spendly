import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_images.dart';
import 'package:spendly/core/constants/app_texts.dart';
import 'package:spendly/core/utils/app_navigations.dart';
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
            AppTexts().mainHeading("Welcome to Spendly"),
            AppTexts().subHeading('Take control of your money with ease. Track your spending, build better habits, and make smarter financial decisions every day.'),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                AppNavigations().navPush(context, Register());
              },
              style: AppButtons.mainPinkButton,
              child: Text('Get Started'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTexts().titleSmall('Already a member?'),
                SizedBox(width: 5),
                InkWell(
                  onTap: () {
                    AppNavigations().navPush(context, Login());
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
