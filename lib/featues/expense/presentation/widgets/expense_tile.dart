import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:spendly/core/constants/app_texts.dart';
import 'package:spendly/featues/category/data/models/category_model.dart';
import 'package:spendly/featues/expense/data/models/expense_model.dart';

class ExpenseTile extends StatefulWidget {
  final VoidCallback? onExpenseEdited;
  const ExpenseTile({super.key, required this.expense,this.onExpenseEdited});

  final Expense expense;

  @override
  State<ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<ExpenseTile> {
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    final expenseDate = DateFormat('dd-MM-yyyy').format(widget.expense.date!);
    final categoryBox = Hive.box<Category>('categories');
    final expenseCategory = categoryBox.get(widget.expense.categoryID);
    final TextEditingController amountController = TextEditingController();
    amountController.text = widget.expense.amount.toString();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    void deleteExpense() {
      widget.expense.delete();
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Expense Deleted")));
    }

    void editExpense() {
      widget.expense.amount = double.parse(amountController.text.trim());
      widget.expense.save();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text("Expense Updated"),
        ),
      );
      widget.onExpenseEdited?.call();
      setState(() {
        isEdit=false;
      });
    }

    void showDetailsDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              final formattedDate = DateFormat(
                'dd-MM-yyyy',
              ).format(widget.expense.date!);
              return isEdit
                  ? _editExpenseDialog(
                      formattedDate,
                      expenseCategory,
                      deleteExpense,
                      context,
                      setDialogState,
                      amountController,
                      formKey,
                      editExpense,
                    )
                  : _expenseDetailsDialog(
                      formattedDate,
                      expenseCategory,
                      deleteExpense,
                      context,
                      setDialogState,
                    );
            },
          );
        },
      );
    }

    return InkWell(
      onTap: () {
        showDetailsDialog();
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: BoxBorder.symmetric(
            horizontal: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              IconData(expenseCategory!.iconCode, fontFamily: 'MaterialIcons'),
            ),
            Text(expenseDate),
            AppTexts().smallHighlightText("₹${widget.expense.amount.toString()}"),
          ],
        ),
      ),
    );
  }

  //edit expense
  AlertDialog _editExpenseDialog(
    String formattedDate,
    Category? expenseCategory,
    void Function() deleteExpense,
    BuildContext context,
    void Function(VoidCallback fn) setDialogState,
    TextEditingController amountController,
    GlobalKey<FormState> formKey,
    void Function() editExpense,
  ) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Wrap(
            // direction: Axis.vertical,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("₹", style: TextStyle(fontSize: 20)),
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
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setDialogState(() {
              isEdit = false;
            });
          },
          icon: Icon(Icons.cancel_outlined),
        ),

        IconButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              editExpense();
            }
          },
          icon: Icon(Icons.check),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  //expense details
  AlertDialog _expenseDetailsDialog(
    String formattedDate,
    Category? expenseCategory,
    void Function() deleteExpense,
    BuildContext context,
    void Function(VoidCallback fn) setDialogState,
  ) {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(15),
        child: Wrap(
          direction: Axis.vertical,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppTexts().smallHighlightText("₹${widget.expense.amount.toString()}"),
            SizedBox(height: 10),
            Text(formattedDate),
            SizedBox(height: 10),
            Row(children: [Text("Category: "), Text(expenseCategory!.name)]),
            SizedBox(height: 10,),
            Row(children: [Text('Notes: '), widget.expense.notes==null?Text("No Notes") :Text(widget.expense.notes!)],)
          ],
        ),
      ),
      actions: [
        Wrap(
          children: [
            IconButton(
              onPressed: () {
                setDialogState(() {
                  isEdit = true;
                });
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                deleteExpense();
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.cancel_outlined),
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    );
  }
}
