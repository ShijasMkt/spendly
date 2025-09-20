import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/my_topbar.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  TextEditingController dateController = TextEditingController();
  String? selectedCategory;
  DateTime? selectedDate;
  DateTime today = DateTime.now();

  @override
  void initState() {
    selectedDate = today;
    dateController.text = DateFormat('dd-MM-yyyy').format(today);
    super.initState();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Container(
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
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(12),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
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
                              items:
                                  [
                                    {"label": "Food", "icon": Icons.fastfood},
                                    {
                                      "label": "Travel",
                                      "icon": Icons.directions_bus,
                                    },
                                    {
                                      "label": "Entertainment",
                                      "icon": Icons.movie,
                                    },
                                    {
                                      "label": "Shopping",
                                      "icon": Icons.shopping_bag
                                    }
                                  ].map((item) {
                                    return DropdownMenuItem(
                                      value: item["label"] as String,
                                      child: Row(
                                        children: [
                                          SizedBox(width: 12),
                                          Icon(item["icon"] as IconData),
                                          SizedBox(width: 10),
                                          Text(
                                            item["label"] as String,
                                            style: TextTheme.of(
                                              context,
                                            ).bodyLarge,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
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
                            ),
                            SizedBox(height: 10),
                            TextFormField(
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
                    ElevatedButton(
                      onPressed: () {},
                      style: AppButtons.mainPinkButton,
                      child: Text("Add"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
