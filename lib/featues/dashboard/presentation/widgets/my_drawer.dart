import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendly/featues/authentication/presentation/providers/auth_provider.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/dashboard/presentation/screens/onboarding_screen.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primaryTealColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                "Spendly",
                style: TextTheme.of(context).displayMedium,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () async{
              ref.read(authProvider.notifier).logout();
              Navigator.push(context,MaterialPageRoute(builder: (_)=>OnboardingScreen()));
            },
          ),
        ],
      ),
    );
  }
}
