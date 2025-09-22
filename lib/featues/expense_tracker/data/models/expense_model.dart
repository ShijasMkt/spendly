import 'package:hive_flutter/hive_flutter.dart';
part 'expense_model.g.dart';

@HiveType(typeId: 1)
class Expense extends HiveObject{
  @HiveField(0)
  String userID;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime? date;

  @HiveField(3)
  int? categoryID;

  Expense({
    required this.userID,
    required this.amount,
    required this.date,
    required this.categoryID
  });
}