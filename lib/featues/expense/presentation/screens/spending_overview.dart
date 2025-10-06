import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/category/data/models/category_model.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';
import 'package:spendly/featues/expense/presentation/widgets/expense_pie_chart.dart';
import 'package:spendly/featues/dashboard/presentation/widgets/my_topbar.dart';

class SpendingOverview extends StatefulWidget {
  const SpendingOverview({super.key});

  @override
  State<SpendingOverview> createState() => _SpendingOverviewState();
}

class _SpendingOverviewState extends State<SpendingOverview> {
  Set<String> selected = {'today'};

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userID = user!.uid;
    final expenseBox = Hive.box<Expense>('expenses');
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    final categoryBox = Hive.box<Category>('categories');

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: _spendingOverviewBody(expenseBox, userID, categoryBox, today),
    );
  }

  //body
  SafeArea _spendingOverviewBody(
    Box<Expense> expenseBox,
    userID,
    Box<Category> categoryBox,
    DateTime today,
  ) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(child: _whiteBody(expenseBox, userID, categoryBox, today)),
        ],
      ),
    );
  }

  //whiteBody
  Container _whiteBody(
    Box<Expense> expenseBox,
    userID,
    Box<Category> categoryBox,
    DateTime today,
  ) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          MyTopbar(pageName: "Spendings Overview"),
          SizedBox(height: 10),
          SegmentedButton<String>(
            showSelectedIcon: false,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.secondaryPinkColor;
                }
                return AppColors.lightGreyColor;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
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
              ButtonSegment(value: "all", label: Text("All")),
            ],
            selected: selected,
            onSelectionChanged: (newSelection) {
              setState(() {
                selected = newSelection;
              });
            },
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: expenseBox.listenable(),
              builder: (context, Box<Expense> box, _) {
                final selectedValue = selected.first;
                List<Expense> expenses = [];
                if (selectedValue == "today") {
                  expenses = expenseBox.values
                      .cast<Expense>()
                      .where(
                        (expense) =>
                            expense.userID == userID && expense.date == today,
                      )
                      .toList();
                } else if (selectedValue == "month") {
                  expenses = expenseBox.values
                      .cast<Expense>()
                      .where(
                        (expense) =>
                            expense.userID == userID &&
                            expense.date!.month == today.month &&
                            expense.date!.year == today.year,
                      )
                      .toList();
                } else if (selectedValue == "all") {
                  expenses = expenseBox.values
                      .cast<Expense>()
                      .where((expense) => expense.userID == userID)
                      .toList();
                }

                final Map<String, double> categoryTotals = {};

                for (var expense in expenses) {
                  final category = categoryBox.get(expense.categoryID);
                  if (category != null) {
                    categoryTotals.update(
                      category.name,
                      (value) => value + expense.amount,
                      ifAbsent: () => expense.amount,
                    );
                  }
                }

                if (categoryTotals.isEmpty) {
                  return const Center(child: Text("No spendings yet"));
                }
                final random = Random();
                final categoryColors = {
                  for (var key in categoryTotals.keys)
                    key: Color.fromARGB(
                      255,
                      random.nextInt(255),
                      random.nextInt(255),
                      random.nextInt(255),
                    ),
                };

                return Column(
                  children: [
                    SizedBox(height: 20),
                    AspectRatio(
                      aspectRatio: 1.2,
                      child: ExpensePieChart(
                        categoryTotals: categoryTotals,
                        categoryColors: categoryColors,
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: categoryTotals.entries.map((entry) {
                          final color = categoryColors[entry.key];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color,
                              radius: 8,
                            ),
                            title: Text(entry.key),
                            trailing: Text(
                              "₹${entry.value.toStringAsFixed(2)}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
