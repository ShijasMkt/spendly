import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_colors.dart';

class AppButtons {
  static final mainPinkButton = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(AppColors.secondaryPinkColor),
    foregroundColor: WidgetStatePropertyAll(Colors.white),
    minimumSize: WidgetStatePropertyAll(Size(double.infinity, 40))
  );
}
