import 'package:flutter/material.dart';

class CustomIconPicker extends StatelessWidget {
  final Function(IconData) onIconSelected;
  const CustomIconPicker({super.key, required this.onIconSelected});

  @override
  Widget build(BuildContext context) {
    final List<IconData> availableIcons = [
      Icons.home,
      Icons.shopping_cart,
      Icons.fastfood,
      Icons.directions_car,
      Icons.movie,
      Icons.fitness_center,
      Icons.school,
      Icons.work,
      Icons.pets,
      Icons.coffee,
    ];
    return GridView.builder(
      padding: EdgeInsets.all(15),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemCount: availableIcons.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onIconSelected(availableIcons[index]),
          child: Icon(availableIcons[index]),
        );
      },
    );
  }
}
