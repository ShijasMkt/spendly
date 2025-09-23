import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/data/models/expense_model.dart';
import 'package:spendly/featues/expense_tracker/data/models/user_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/functions/month_spendings.dart';
import 'package:spendly/featues/expense_tracker/presentation/functions/today_spendings.dart';
import 'package:spendly/featues/expense_tracker/presentation/functions/total_spendings.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/add_expense.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/spending_history.dart';
import 'package:spendly/featues/expense_tracker/presentation/screens/spending_overview.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/category_spending_builder.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/my_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selected = 'today';
  late Box settingsBox;
  late Box userBox;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    settingsBox = Hive.box('settingsBox');
    userBox = Hive.box<User>('users');
  }

  @override
  Widget build(BuildContext context) {
    final userID = settingsBox.get('currentUser');
    final user = userBox.get(userID) as User?;
    final totalSpend = totalSpendings(userID);
    final todaySpend = todaySpendings(userID);
    final monthSpend = monthSpendings(userID);
    String formattedToday = DateFormat('d MMMM y').format(today);
    String formattedMonth = DateFormat('MMMM y').format(today);
    final expenseBox = Hive.box<Expense>('expenses');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      drawer: MyDrawer(user: user),
      bottomNavigationBar: bottomNav(),
      body: _body(
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

  // appbar
  AppBar _appBar() => AppBar(backgroundColor: AppColors.primaryTealColor);

  // body
  SafeArea _body(
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
                Text(
                  "My spendings",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "$totalSpend",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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
                  return Color(0xffd5d5d5);
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
                            Text(
                              formattedToday,
                              style: TextTheme.of(context).bodyLarge,
                            ),
                            Text(
                              "$todaySpend",
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                            Text(
                              formattedMonth,
                              style: TextTheme.of(context).bodyLarge,
                            ),
                            Text(
                              "$monthSpend",
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SpendingHistory()),
                );
              },
              icon: Icon(Icons.history, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SpendingOverview()),
                );
              },
              icon: Icon(Icons.pie_chart, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.notifications, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddExpense(
                      onExpenseAdded: () {
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
