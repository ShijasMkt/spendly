import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/add_expense.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/spending_history.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/spending_overview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selected = 'today';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: AppColors.primaryTealColor),
      drawer: _myDrawer(),
      bottomNavigationBar: bottomNav(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primaryTealColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My spendings",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "₹10,000",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    SegmentedButton<String>(
                      showSelectedIcon: false,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.secondaryPinkColor;
                          }
                          return Color(0xffd5d5d5);
                        }),
                        foregroundColor: WidgetStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return Colors.white;
                          }
                          return AppColors.secondaryPinkColor;
                        }),
                        side: WidgetStatePropertyAll(BorderSide.none),
                        padding: WidgetStatePropertyAll(EdgeInsets.all(15)),
                      ),
                      segments: [
                        ButtonSegment(value: "today", label: Text("Today")),
                        ButtonSegment(value: "month", label: Text("Month")),
                      ],
                      selected: {selected},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          selected = newSelection.first;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "18 September 2025",
                          style: TextTheme.of(context).bodyLarge,
                        ),
                        Text(
                          "270",
                          style: TextStyle(
                            color: Colors.red.shade800,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //Drawer section
  Drawer _myDrawer() {
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
              "Hi Shijas...",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  //Bottom NAvigation//////
  Padding bottomNav() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.secondaryPinkColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>SpendingHistory()));
              },
              icon: Icon(Icons.history, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_)=>SpendingOverview()));
              },
              icon: Icon(Icons.pie_chart, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AddExpense()),
                );
              },
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
