import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/featues/expense_tracker/data/models/category_model.dart';
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/expense_pie_chart.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/my_topbar.dart';

class SpendingOverview extends StatelessWidget {
  const SpendingOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box('settingsBox');
    final userID = settingsBox.get('currentUser');
    final expenseBox = Hive.box<Expense>('expenses');
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    final categoryBox = Hive.box<Category>('categories');

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Container(
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
                    Expanded(
                      child: Column(
                        children: [
                          MyTopbar(pageName: "Spendings Overview"),
                          SizedBox(height: 20),
                          Expanded(
                            child: ValueListenableBuilder(
                              valueListenable: expenseBox.listenable(),
                              builder: (context, Box<Expense> box, _) {
                                final expenses = box.values
                                    .cast<Expense>()
                                    .where(
                                      (expense) => expense.userID == userID,
                                    )
                                    .toList();

                                final Map<String, double> categoryTotals = {};

                                for (var expense in expenses) {
                                  final category = categoryBox.get(
                                    expense.categoryID,
                                  );
                                  if (category != null) {
                                    categoryTotals.update(
                                      category.name,
                                      (value) => value + expense.amount,
                                      ifAbsent: () => expense.amount,
                                    );
                                  }
                                }

                                if(categoryTotals.isEmpty){
                                  return const Center(
                                    child: Text("No spendings yet"),
                                  );
                                }

                                return ExpensePieChart(categoryTotals: categoryTotals);
                              },
                            ),
                          ),
                        ],
                      ),
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
}
