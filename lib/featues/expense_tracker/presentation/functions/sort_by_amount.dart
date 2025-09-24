import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';

List<Expense> sortByAmount(List<Expense> expenses) {
  expenses.sort((a,b){
    return b.amount.compareTo(a.amount);
  });
  return expenses;
}
