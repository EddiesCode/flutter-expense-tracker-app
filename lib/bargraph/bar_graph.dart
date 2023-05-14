import 'package:flutter/material.dart';
import "package:fl_chart/fl_chart.dart";
import 'package:flutter_expense_tracker/bargraph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final double? maxY;
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;
  final double satAmount;

  const MyBarGraph({
    super.key,
    required this.maxY,
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thurAmount,
    required this.friAmount,
    required this.satAmount,
  });

  @override
  Widget build(BuildContext context) {
    // initialize bardata
    BarData myBarData = BarData(
        monAmount: monAmount,
        tueAmount: tueAmount,
        wedAmount: wedAmount,
        thurAmount: thurAmount,
        friAmount: friAmount,
        satAmount: satAmount,
        sunAmount: sunAmount);

    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white,
          ),
        ),
        maxY: maxY,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: getBottomTitles,
                    reservedSize: 20))),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(x: data.x, barRods: [
                  BarChartRodData(
                    color: Colors.grey[800],
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      color: Colors.grey[200],
                      toY: maxY,
                      show: true,
                    ),
                    toY: data.y,
                  )
                ]))
            .toList(),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
  );
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        "Mon",
        style: style,
      );
      break;
    case 1:
      text = const Text(
        "Tue",
        style: style,
      );
      break;
    case 2:
      text = const Text(
        "Wed",
        style: style,
      );
      break;
    case 3:
      text = const Text(
        "Thu",
        style: style,
      );
      break;
    case 4:
      text = const Text(
        "Fri",
        style: style,
      );
      break;
    case 5:
      text = const Text(
        "Sat",
        style: style,
      );
      break;
    case 6:
      text = const Text(
        "Sun",
        style: style,
      );
      break;
    default:
      text = const Text(
        "",
      );
      break;
  }

  return FittedBox(
    fit: BoxFit.fitWidth,
    child: text,
  );

  /* return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  ); */
}
