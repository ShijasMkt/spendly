import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/core/constants/app_fonts.dart';

ThemeData myAppTheme() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryTealColor,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      // iconTheme: IconThemeData(
      //   color: Colors.white
      // ),
      scaffoldBackgroundColor: AppColors.primaryTealColor,
      fontFamily: AppFonts.poppins,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryTealColor),
      textTheme: myTextTheme
    );
  }

  var myTextTheme = TextTheme(
  bodyLarge: TextStyle(
    color: AppColors.secondaryPinkColor,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  ),
  bodyMedium: TextStyle(color: Colors.black),
  bodySmall: TextStyle(color: Colors.white),
  titleLarge: const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: Colors.white,
  ),
  titleMedium: const TextStyle(fontSize: 20, color: Colors.white),
  titleSmall: const TextStyle(fontSize: 14, color: Colors.white),
  labelLarge: const TextStyle(color: Colors.white),
  labelMedium: const TextStyle(color: Colors.white),
  labelSmall: const TextStyle(color: Colors.white),
  displayLarge: const TextStyle(color: Colors.white),
  displayMedium: const TextStyle(color: Colors.white),
  displaySmall: const TextStyle(color: Colors.white),
  headlineLarge: const TextStyle(color: Colors.white),
  headlineMedium: const TextStyle(color: Colors.white),
  headlineSmall: const TextStyle(color: Colors.white),
);