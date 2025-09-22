import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/data/models/category_model.dart';
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/functions/sort_by_date.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/my_topbar.dart';

class SpendingHistory extends StatelessWidget {
  const SpendingHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseBox = Hive.box<Expense>('expenses');
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
                    MyTopbar(pageName: "Spendings History"),
                    SizedBox(height: 20),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: expenseBox.listenable(),
                        builder: (context, Box<Expense> box, _) {
                          var expenses = box.values.toList();
                          expenses=sortByDate(expenses);
                          if (expenses.isEmpty) {
                            return Text("No Expenses!");
                          }
                          return ListView.builder(
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              final expense = expenses[index];
                              final expenseDate = DateFormat(
                                'dd-MM-yyyy',
                              ).format(expense.date!);
                              final expenseCategory = categoryBox.get(
                                expense.categoryID,
                              );
                              return Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: BoxBorder.symmetric(horizontal: BorderSide(color: Colors.black,width: 1))
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      IconData(
                                        expenseCategory!.iconCode,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                    ),
                                    Text(expenseDate),
                                    Text("₹${expense.amount.toString()}",style: TextStyle(color: AppColors.highlightRedColor),),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
