import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/featues/expense_tracker/data/models/category_model.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/category_tile.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/custom_icon_picker.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/my_topbar.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController categoryController = TextEditingController();
  IconData? selectedIcon;
  final categoryBox = Hive.box<Category>('categories');

  Future<void> _pickIcon() async {
    selectedIcon = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return CustomIconPicker(
          onIconSelected: (icon) {
            Navigator.pop(context, icon);
            setState(() {
              selectedIcon = icon;
            });
          },
        );
      },
    );
  }

  void saveCategory() {
    final categoryName = categoryController.text.trim();

    final existingCategory = categoryBox.values
        .cast<Category>()
        .where((category) => category.name == categoryName)
        .toList();

    if (existingCategory.isNotEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Category already exists!")));
      return;
    }

    final newCategory = Category(
      name: categoryName,
      iconCode: selectedIcon!.codePoint,
    );
    categoryBox.add(newCategory);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text("Category Added!")),
    );

    categoryController.clear();
    setState(() {
      selectedIcon = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: _addCategoryBody(context),
    );
  }

  //body
  SafeArea _addCategoryBody(BuildContext context) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(child: _whiteBody(context)),
          ],
        ),
      ),
    );
  }

  //whitebody
  Container _whiteBody(BuildContext context) {
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
          MyTopbar(pageName: "Add Category"),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(label: Text("Category Name")),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a category";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Selected Icon:  ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(selectedIcon),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickIcon,
                  child: Text("Pick a Icon"),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: categoryBox.listenable(),
              builder: (context, Box<Category> box, _) {
                final categories = box.values.toList();

                if (categories.isEmpty) {
                  return Text("No Categories added");
                }
                return Scrollbar(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryTile(category: category);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate() && selectedIcon != null) {
                saveCategory();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("Please select a icon!"),
                  ),
                );
              }
            },
            style: AppButtons.mainPinkButton,
            child: Text("Add"),
          ),
        ],
      ),
    );
  }
}
