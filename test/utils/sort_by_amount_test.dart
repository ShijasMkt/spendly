import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';
import 'package:spendly/featues/category/presentation/functions/sort_by_amount.dart';

void main(){
  test('Sort by amount sorts expenses descending', (){
    final expenses=[
      Expense(userID: '1', amount: 10, date: DateTime.now(), categoryID: 1),
      Expense(userID: '1', amount: 50, date: DateTime.now(), categoryID: 2),
      Expense(userID: '1', amount: 30, date: DateTime.now(), categoryID: 3)
    ];

    final sorted = sortByAmount(expenses);

    expect(sorted[0].amount, 50);
    expect(sorted[1].amount, 30);
    expect(sorted[2].amount, 10);

  });
}