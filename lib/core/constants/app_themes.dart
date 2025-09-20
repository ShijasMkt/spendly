import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/core/constants/app_fonts.dart';
import 'package:spendly/core/constants/app_texts.dart';

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