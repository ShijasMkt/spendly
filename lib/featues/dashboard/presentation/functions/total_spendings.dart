import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';

double totalSpendings(String userID) {
  final expenseBox = Hive.box<Expense>('expenses');
  final expenses = expenseBox.values
      .cast<Expense>()
      .where((expense) => expense.userID == userID)
      .toList();

  double total = 0;

  for (var expense in expenses) {
    total += expense.amount;
  }

  return total;
}
