import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';

double todaySpendings(String userID) {
  final expenseBox = Hive.box<Expense>('expenses');
  DateTime today = DateTime.now();
  today = DateTime(today.year, today.month, today.day);
  final expenses = expenseBox.values
      .cast<Expense>()
      .where((expense) => expense.userID == userID && expense.date==today)
      .toList();

  double total = 0;

  for (var expense in expenses) {
    total+=expense.amount;
  }

  return total;
}
