import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryTotals; 
  const ExpensePieChart({super.key,required this.categoryTotals});

  @override
  Widget build(BuildContext context) {

    double calculatePercent(double num){
    double total=0;

      for(var entry in categoryTotals.entries){
        total=total+entry.value;
      }
      final temp=num/total;
      return temp*100;
    }
    return PieChart(PieChartData(
      sections: categoryTotals.entries.map((index){
        final random=Random(index.hashCode);
        return PieChartSectionData(
          color: Color.fromARGB(255, random.nextInt(255), random.nextInt(255) , random.nextInt(255)),
          value: index.value,
          title: "${calculatePercent(index.value).toStringAsFixed(2)}%",
          radius: 80,
          titleStyle: TextStyle(
            color: Colors.white
          )
        );
      }).toList(),
      sectionsSpace: 2,
      centerSpaceRadius: 30
    ));
  }
}