import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/core/auth/auth_provider.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/data/models/user_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/add_category.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/onboarding_screen.dart';

class MyDrawer extends ConsumerWidget {
  final User? user;
  const MyDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final settingsBox= Hive.box('settingsBox');
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
            child: Text(
              "Hi ${user!.uName}...",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text("Add Categories"),
            onTap: () {
              Navigator.push(context,MaterialPageRoute(builder: (_)=>AddCategory()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () {
              settingsBox.put('isLoggedIn', false);
              ref.read(authProvider.notifier).logout();
              Navigator.push(context,MaterialPageRoute(builder: (_)=>OnboardingScreen()));
            },
          ),
        ],
      ),
    );
  }
}
