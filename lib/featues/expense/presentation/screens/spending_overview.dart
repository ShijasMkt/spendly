import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/featues/category/data/models/category_model.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';
import 'package:spendly/featues/expense/presentation/widgets/expense_pie_chart.dart';
import 'package:spendly/featues/dashboard/presentation/widgets/my_topbar.dart';

class SpendingOverview extends StatelessWidget {
  const SpendingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userID=user!.uid;
    final expenseBox = Hive.box<Expense>('expenses');
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    final categoryBox = Hive.box<Category>('categories');

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: _spendingOverviewBody(expenseBox, userID, categoryBox),
    );
  }

  //body
  SafeArea _spendingOverviewBody(
    Box<Expense> expenseBox,
    userID,
    Box<Category> categoryBox,
  ) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(child: _whiteBody(expenseBox, userID, categoryBox)),
        ],
      ),
    );
  }

  //whiteBody
  Container _whiteBody(
    Box<Expense> expenseBox,
    userID,
    Box<Category> categoryBox,
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
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: expenseBox.listenable(),
              builder: (context, Box<Expense> box, _) {
                final expenses = box.values
                    .cast<Expense>()
                    .where((expense) => expense.userID == userID)
                    .toList();

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
                    Text("Overall spending by category:"),
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
