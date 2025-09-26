import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';

double monthSpendings(String userID) {
  final expenseBox = Hive.box<Expense>('expenses');
  DateTime today = DateTime.now();

  final expenses = expenseBox.values
      .cast<Expense>()
      .where((expense) => expense.userID == userID && expense.date!.year==today.year && expense.date!.month==today.month) 
      .toList();

  double total=0;

  for(var expense in expenses){
    total+=expense.amount;
  }    

  return total;
}
