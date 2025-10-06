import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/core/constants/app_texts.dart';
import 'package:spendly/core/utils/app_navigations.dart';
import 'package:spendly/featues/category/presentation/screens/add_category.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';
import 'package:spendly/featues/dashboard/presentation/functions/month_spendings.dart';
import 'package:spendly/featues/dashboard/presentation/functions/today_spendings.dart';
import 'package:spendly/featues/dashboard/presentation/functions/total_spendings.dart';
import 'package:spendly/featues/expense/presentation/screens/add_expense.dart';
import 'package:spendly/featues/expense/presentation/screens/spending_history.dart';
import 'package:spendly/featues/expense/presentation/screens/spending_overview.dart';
import 'package:spendly/featues/category/presentation/widgets/category_spending_builder.dart';
import 'package:spendly/featues/dashboard/presentation/widgets/my_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selected = 'today';
  DateTime today = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userID = user!.uid;
    final expenseBox = Hive.box<Expense>('expenses');
    final totalSpend = totalSpendings(userID, expenseBox);
    final todaySpend = todaySpendings(userID, expenseBox);
    final monthSpend = monthSpendings(userID, expenseBox);
    String formattedToday = DateFormat('d MMMM y').format(today);
    String formattedMonth = DateFormat('MMMM y').format(today);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      backgroundColor: Colors.white,
      appBar: _appBar(),
      drawer: MyDrawer(),
      bottomNavigationBar: bottomNav(),
      floatingActionButton: _floatingActionButton(context),
      body: _mainBody(
        context,
        totalSpend,
        formattedToday,
        todaySpend,
        formattedMonth,
        monthSpend,
        expenseBox,
        userID,
      ),
    );
  }

  //floating action button
  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.primaryTealColor,
      shape: CircleBorder(),
      onPressed: () {
        AppNavigations().navPush(
          context,
          AddExpense(
            onExpenseAdded: () {
              setState(() {});
            },
          ),
        );
      },
      child: Icon(Icons.add, color: Colors.white),
    );
  }

  // appbar
  AppBar _appBar() => AppBar(backgroundColor: AppColors.primaryTealColor);

  // body
  SafeArea _mainBody(
    BuildContext context,
    double totalSpend,
    String formattedToday,
    double todaySpend,
    String formattedMonth,
    double monthSpend,
    Box<Expense> expenseBox,
    String userID,
  ) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.primaryTealColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTexts().titleMedium("My spendings"),
                AppTexts().titleLarge("₹ $totalSpend"),
                SizedBox(height: 10),
              ],
            ),
          ),
          // white body
          _whiteBody(
            formattedToday,
            context,
            todaySpend,
            formattedMonth,
            monthSpend,
            expenseBox,
            userID,
          ),
        ],
      ),
    );
  }

  Expanded _whiteBody(
    String formattedToday,
    BuildContext context,
    double todaySpend,
    String formattedMonth,
    double monthSpend,
    Box<Expense> expenseBox,
    String userID,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 20),
            SegmentedButton<String>(
              showSelectedIcon: false,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.secondaryPinkColor;
                  }
                  return AppColors.lightGreyColor;
                }),
                foregroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return AppColors.secondaryPinkColor;
                }),
                side: WidgetStatePropertyAll(BorderSide.none),
                padding: WidgetStatePropertyAll(EdgeInsets.all(15)),
              ),
              segments: [
                ButtonSegment(value: "today", label: Text("Today")),
                ButtonSegment(value: "month", label: Text("Month")),
              ],
              selected: {selected},
              onSelectionChanged: (newSelection) {
                setState(() {
                  selected = newSelection.first;
                });
              },
            ),
            SizedBox(height: 20),

            selected == "today"
                ? Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTexts().bodyLarge(formattedToday),
                            AppTexts().highlightText("₹ $todaySpend"),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: CategorySpendingBuilder(
                            userID: userID,
                            isToday: selected == "today",
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppTexts().bodyLarge(formattedMonth),
                            AppTexts().highlightText("₹ $monthSpend"),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: CategorySpendingBuilder(
                            userID: userID,
                            isToday: selected == "today",
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  //Bottom NAvigation//////
  Padding bottomNav() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.secondaryPinkColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                AppNavigations().navPush(
                  context,
                  SpendingHistory(
                    onExpenseEdited: () {
                      setState(() {});
                    },
                  ),
                );
              },
              icon: Icon(Icons.history, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                AppNavigations().navPush(context, SpendingOverview());
              },
              icon: Icon(Icons.pie_chart, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                AppNavigations().navPush(context, AddCategory());
              },
              icon: Icon(Icons.category, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
