import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_colors.dart';
import 'package:spendly/featues/expense_tracker/data/models/category_model.dart';

class CategoryTile extends StatefulWidget {
  final Category category;
  const CategoryTile({super.key, required this.category});

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  void deleteCategory() {
    widget.category.delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Category Deleted!")));
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          content: Text("Do you really want to delete?"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined),
            ),
            IconButton(
              onPressed: () {
                deleteCategory();
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xff88819E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                IconData(widget.category.iconCode, fontFamily: 'MaterialIcons'),
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                widget.category.name,
                style: TextTheme.of(context).titleMedium,
              ),
            ],
          ),

          IconButton(
            onPressed: () {
              showDeleteDialog();
            },
            icon: Icon(Icons.delete),
            color: AppColors.highlightRedColor,
          ),
        ],
      ),
    );
  }
}
