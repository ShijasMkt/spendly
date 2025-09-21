import 'package:flutter/material.dart';
import 'package:spendly/core/constants/app_buttons.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/custom_icon_picker.dart';
import 'package:spendly/featues/expense_tracker/presentation/widgets/my_topbar.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  IconData? selectedIcon;
  Future<void> _pickIcon() async {
    selectedIcon=await showModalBottomSheet(context: context, builder: (context) {
      return CustomIconPicker(onIconSelected: (icon){
        Navigator.pop(context,icon);
        setState(() {
          selectedIcon=icon;
        });
      });
      
    },);
    
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
                    MyTopbar(pageName: "Add Category"),
                    SizedBox(height: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                label: Text("Category Name"),
                              ),
                            ),
                            Icon(selectedIcon),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _pickIcon,
                              child: Text("Pick a Icon"),
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
