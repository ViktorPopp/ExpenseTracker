import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'individual_bar.dart';

class ExpenseBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;
  const ExpenseBarGraph(
      {super.key, required this.monthlySummary, required this.startMonth});

  @override
  State<ExpenseBarGraph> createState() => _ExpenseBarGraphState();
}

class _ExpenseBarGraphState extends State<ExpenseBarGraph> {
  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = List.generate(
      widget.monthlySummary.length,
      (index) => IndividualBar(
        x: index,
        y: widget.monthlySummary[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
      ),
    );
  }
}
