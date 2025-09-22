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
              SizedBox(width: 10,),
              Text(
                widget.category.name,
                style: TextTheme.of(context).titleMedium,
              ),
            ],
          ),

          IconButton(onPressed: () {}, icon: Icon(Icons.delete),color: AppColors.highlightRedColor,),
        ],
      ),
    );
  }
}
