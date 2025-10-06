import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/core/constants/app_themes.dart';

class AppTexts {
  Text highlightText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.red.shade800,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Text mainHeading(String text) {
    return Text(
      text,
      style: myTextTheme.titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Text subHeading(String text) {
    return Text(
      text,
      style: myTextTheme.titleSmall,
      textAlign: TextAlign.center,
    );
  }

  Text bodyLarge(String text) {
    return Text(text, style: myTextTheme.bodyLarge);
  }

  Text titleLarge(String text) {
    return Text(text, style: myTextTheme.titleLarge);
  }

  Text titleMedium(String text) {
    return Text(text, style: myTextTheme.titleMedium);
  }

  Text titleSmall(String text) {
    return Text(text, style: myTextTheme.titleSmall);
  }

  Text smallHighlightText(String text) {
    return Text(
      text,
      style: TextStyle(color: AppColors.highlightRedColor, fontSize: 20),
    );
  }
}
