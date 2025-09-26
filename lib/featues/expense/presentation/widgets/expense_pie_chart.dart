import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryTotals; 
  final Map<String, Color> categoryColors;
  const ExpensePieChart({super.key,required this.categoryTotals,required this.categoryColors});

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
        return PieChartSectionData(
          color: categoryColors[index.key],
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