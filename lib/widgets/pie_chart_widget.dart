import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:fuelwise/models/chart_data.dart'; // Import the ChartData model

class PieChartWidget extends StatelessWidget {
  final List<ChartData> chartData;

  PieChartWidget({required this.chartData});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: {
        for (var data in chartData) data.label: data.percentage,
      },
      colorList: [for (var data in chartData) data.color],
      chartRadius: MediaQuery.of(context).size.width / 1.5,
      chartType: ChartType.disc,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 10.0,
      // chartLegendPosition: ChartLegendPosition.bottom,
      initialAngleInDegree: 0,
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}
