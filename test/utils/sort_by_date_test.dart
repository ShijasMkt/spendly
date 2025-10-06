import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';
import 'package:spendly/featues/expense/presentation/functions/sort_by_date.dart';

void main(){
  test('sort the expenses by date (latest first)', (){
    final expenses=[
      Expense(userID: '1', amount: 100, date: DateTime(2025,5,10), categoryID: 1),
      Expense(userID: '1', amount: 30, date: DateTime(2023,12,1), categoryID: 3),
      Expense(userID: '1', amount: 40, date: DateTime(2025,8,15), categoryID: 2),
    ];

    final sorted = sortByDate(expenses);

    expect(sorted[0].date, DateTime(2025,8,15));
    expect(sorted[1].date, DateTime(2025,5,10));
    expect(sorted[2].date, DateTime(2023,12,1));
  });
}
