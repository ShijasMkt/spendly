import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/core/constants/app_themes.dart';

class MyTopbar extends StatelessWidget {
  final String pageName;
  const MyTopbar({super.key,required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: CloseButton(color: AppColors.secondaryPinkColor),
        ),
        Text(pageName, style: myTextTheme.bodyLarge),
      ],
    );
  }
}
