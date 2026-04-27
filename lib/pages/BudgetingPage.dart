import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serene/SomeConstants.dart';

class BudgetingPage extends StatefulWidget {
  const BudgetingPage({super.key});
  @override
  State<BudgetingPage> createState() => _BudgetingPageState();
}

class _BudgetingPageState extends State<BudgetingPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("Placeholder"),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 10,
                      color: Colors.green,
                      radius: 20,
                    ),
                    PieChartSectionData(value: 20, radius: 20),
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                ),
              ),
            ),

            Column(
              children: [
                const Text(
                  "Total Spent",
                  style: TextStyle(fontWeight: FontWeight(400)),
                ),
                Text(
                  "Rs.50000",
                  style: TextStyle(fontWeight: FontWeight(700), fontSize: 20),
                ),
                Text(
                  "of Rs.100000",
                  style: TextStyle(
                    fontSize: 14,
                    color: PRIMARYCOLOR,
                    fontWeight: FontWeight(500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
