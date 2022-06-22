import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';

class PersonalPieChart extends StatelessWidget {
  const PersonalPieChart({
    Key? key,
    required this.data,
    required this.kk, required this.legendLabel, this.centerText, required this.height,
  }) : super(key: key);

  final Map<String, double> data;
  final Map kk;
  final Map<String,String> legendLabel;
  final centerText;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(

        color: Colors.white,
        elevation: 15,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Container(
          height: height,
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),),
          child: Center(
            child: PieChart(
              dataMap: data,
              centerText: centerText,
              legendLabels: legendLabel,

              legendOptions: LegendOptions(legendPosition: LegendPosition.bottom,showLegendsInRow: true),
              chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
                decimalPlaces: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
