import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/category/data/models/category_model.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';
import 'package:spendly/featues/category/presentation/screens/add_category.dart';
import 'package:spendly/featues/dashboard/presentation/widgets/my_topbar.dart';

class AddExpense extends StatefulWidget {
  final VoidCallback? onExpenseAdded;

  const AddExpense({super.key, this.onExpenseAdded});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  final expenseBox = Hive.box<Expense>('expenses');
  final categoryBox = Hive.box<Category>('categories');

  int? selectedCategory;
  DateTime? selectedDate;
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(today.year, today.month, today.day);
    dateController.text = DateFormat('dd-MM-yyyy').format(today);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('dd-MM-yyyy').format(picked);
        selectedDate = DateTime(picked.year, picked.month, picked.day);
      });
    }
  }

  void saveExpense() {
    final amount = double.parse(amountController.text.trim());
    final user = FirebaseAuth.instance.currentUser;
    final userID = user!.uid;

    final newExpense = Expense(
      userID: userID,
      amount: amount,
      date: selectedDate,
      categoryID: selectedCategory,
      notes: noteController.text.trim().isEmpty? null :noteController.text.trim()
    );
    expenseBox.add(newExpense);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text("Expense added!")),
    );
    widget.onExpenseAdded?.call();
    amountController.clear();
    noteController.clear();
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = categoryBox.values.toList();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: _addExpenseBody(categories, context),
    );
  }

  //body
  SafeArea _addExpenseBody(List<Category> categories, BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 10),
          Expanded(child: _whiteBody(categories, context)),
        ],
      ),
    );
  }

  //whitebody
  Container _whiteBody(List<Category> categories, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          MyTopbar(pageName: "Add Expense"),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.primaryTealColor,
                          ),
                          child: Text(
                            "  INR  ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: 165,
                          child: TextFormField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(12),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the amount";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    DropdownButton(
                      isExpanded: true,
                      icon: Icon(Icons.arrow_forward_ios),
                      hint: Text(
                        "Choose a category",
                        style: TextStyle(color: Color(0xffd5d5d5)),
                      ),
                      value: selectedCategory,
                      items: [
                        ...categories.map((item) {
                          return DropdownMenuItem<int>(
                            value: item.key as int,
                            child: Row(
                              children: [
                                SizedBox(width: 12),
                                Icon(
                                  IconData(
                                    item.iconCode,
                                    fontFamily: 'MaterialIcons',
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  item.name,
                                  style: TextTheme.of(context).bodyLarge,
                                ),
                              ],
                            ),
                          );
                        }),
                        _dropDownMenu(context),
                      ],
                      onChanged: (value) {
                        if (value == -1) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddCategory()),
                          );
                          setState(() {
                            selectedCategory = null;
                          });
                        } else {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: dateController,
                      onTap: () {
                        _selectDate(context);
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit_calendar),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please give a date";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: noteController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.notes),
                        hint: Text(
                          "Notes",
                          style: TextStyle(color: Color(0xffd5d5d5)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                saveExpense();
              }
            },
            style: AppButtons.mainPinkButton,
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  //dropdownMenu
  DropdownMenuItem<int> _dropDownMenu(BuildContext context) {
    return DropdownMenuItem<int>(
      value: -1,
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Color(0xffd5d5d5),
          borderRadius: BorderRadius.circular(5),
        ),

        child: Row(
          children: [
            SizedBox(width: 12),
            Icon(Icons.add),
            SizedBox(width: 10),
            Text("Add new Category", style: TextTheme.of(context).bodyLarge),
          ],
        ),
      ),
    );
  }
}
