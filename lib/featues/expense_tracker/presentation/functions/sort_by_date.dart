
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';
List<Expense> sortByDate(List<Expense> expenses) {
  expenses.sort((a,b){
    if(a.date==null && b.date==null) return 0;
    if(a.date==null) return 1;
    if(b.date==null) return -1;
    return b.date!.compareTo(a.date!);
  });
  return expenses;
}
