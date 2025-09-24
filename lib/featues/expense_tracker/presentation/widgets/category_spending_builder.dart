import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/data/models/category_model.dart';
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/functions/sort_by_amount.dart';

class CategorySpendingBuilder extends StatelessWidget {
  const CategorySpendingBuilder({
    super.key,
    required this.userID,
    required this.isToday
  });

  final String userID;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final expenseBox = Hive.box<Expense>('expenses');
    DateTime today=DateTime.now();
    today=DateTime(today.year,today.month,today.day);
    List<Expense> expenses;
    return ValueListenableBuilder(
      valueListenable: expenseBox.listenable(),
      builder: (context, Box<Expense> box, _) {
        
        if(isToday){
          expenses = box.values.cast<Expense>().where(
          (expense) =>
              expense.userID == userID && expense.date==today,
        ).toList();
        }else{
          expenses = box.values.cast<Expense>().where(
          (expense) =>
              expense.userID == userID &&
              expense.date!.month == today.month &&
              expense.date!.year == today.year,
        ).toList();
        }
        expenses=sortByAmount(expenses);
        
        final Map<String, double> categoryTotals = {};
    
        final categoryBox = Hive.box<Category>(
          'categories',
        );
    
        for (var expense in expenses) {
          final category = categoryBox.get(
            expense.categoryID,
          );
          if (category != null) {
            categoryTotals.update(
              category.name,
              (value) => value + expense.amount,
              ifAbsent: () => expense.amount,
            );
          }
        }
    
        return categoryTotals.isEmpty? Center(child: Text("No spendings!"),): ListView(
          children: categoryTotals.entries.map((index) {
            return ListTile(
              title: Text(index.key),
              trailing: Text(index.value.toString(),style: TextStyle(color: AppColors.highlightRedColor),),
            );
          }).toList(),
        );
      },
    );
  }
}