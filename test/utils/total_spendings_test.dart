import 'package:flutter_test/flutter_test.dart';
import 'package:spendly/featues/dashboard/presentation/functions/total_spendings.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';

class FakeExpenseBox {
  final List<Expense> _values;
  FakeExpenseBox(this._values);

  Iterable<Expense> get values => _values;
}

void main() {
  test('return total spending for a user', () {
    final now = DateTime.now();

    final fakeBox = FakeExpenseBox([
      Expense(
        userID: 'user1',
        amount: 100,
        date: DateTime(now.year, now.month, now.day),
        categoryID: 1,
      ),
      Expense(
        userID: 'user1',
        amount: 50,
        date: DateTime(now.year, now.month - 1, 15),
        categoryID: 2,
      ),
      Expense(
        userID: 'user2',
        amount: 200,
        date: DateTime(now.year, now.month, now.day),
        categoryID: 3,
      ),
    ]);

    final total = totalSpendings('user1', fakeBox as dynamic);

    expect(total, 150);
  });

  test('return 0 if user has no expenses', () {

    final fakeBox = FakeExpenseBox([]);

    final total = totalSpendings('user1', fakeBox as dynamic);

    expect(total, 0);
  });
}
