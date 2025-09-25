import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/featues/expense_tracker/data/models/category_model.dart';
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/functions/sort_by_date.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/expense_tile.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/my_topbar.dart';

class SpendingHistory extends StatelessWidget {
  final VoidCallback? onExpenseEdited;
  const SpendingHistory({super.key,this.onExpenseEdited});

  @override
  Widget build(BuildContext context) {
    final expenseBox = Hive.box<Expense>('expenses');
    final categoryBox = Hive.box<Category>('categories');

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: _spendingHistoryBody(expenseBox, categoryBox),
    );
  }

  //body
  SafeArea _spendingHistoryBody(
    Box<Expense> expenseBox,
    Box<Category> categoryBox,
  ) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: _whiteBody(expenseBox, categoryBox),
          ),
        ],
      ),
    );
  }
  //whiteBody
  Container _whiteBody(Box<Expense> expenseBox, Box<Category> categoryBox) {
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
                MyTopbar(pageName: "Spendings History"),
                SizedBox(height: 20),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: expenseBox.listenable(),
                    builder: (context, Box<Expense> box, _) {
                      final user = FirebaseAuth.instance.currentUser;
                      final userID = user!.uid;

                      var expenses = box.values
                          .cast<Expense>()
                          .where((expense) => expense.userID == userID)
                          .toList();
                      expenses = sortByDate(expenses);
                      if (expenses.isEmpty) {
                        return Text("No Expenses!");
                      }
                      return ListView.builder(
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];
                          return ExpenseTile(expense: expense, onExpenseEdited:() {
                            onExpenseEdited?.call();
                          },);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}


