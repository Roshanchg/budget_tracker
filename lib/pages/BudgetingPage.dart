import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serene/Enums/category.dart';
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
      padding: EdgeInsetsGeometry.directional(start: 20, top: 20, end: 20),
      children: [
        Container(
          color: null,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsetsGeometry.directional(
            start: 10,
            end: 10,
            top: 20,
            bottom: 20,
          ),
          child: Column(
            children: [
              Text(
                "Monthly Budget",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight(450),
                  fontSize: 24,
                ),
              ),
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
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 20,
                            radius: 20,
                            showTitle: false,
                          ),
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
                        style: TextStyle(
                          fontWeight: FontWeight(700),
                          fontSize: 20,
                        ),
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

              Text("LEGEND PLACEHOLDER"),
            ],
          ),
        ),

        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Categories",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight(450),
                  fontSize: 20,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(children: [Icon(Icons.add), Text("New Category")]),
              ),
            ],
          ),
        ),

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  color: null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  padding: EdgeInsetsGeometry.directional(
                    start: 20,
                    end: 20,
                    top: 15,
                    bottom: 15,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: CATEGORY.RENT.bgcolor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(8),

                            child: Icon(
                              CATEGORY.RENT.icon,
                              color: CATEGORY.RENT.fgcolor,
                              size: 30,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CATEGORY.RENT.displayName,
                                style: TextStyle(fontWeight: FontWeight(500)),
                              ),
                              Text(
                                "Rs.10000",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight(500),
                                ),
                              ),
                            ],
                          ),
                          Text("of Rs.10000"),
                        ],
                      ),
                      SizedBox(height: 20),
                      LinearProgressIndicator(
                        borderRadius: BorderRadius.circular(8),
                        minHeight: 8,
                        value: .9,
                        color: CATEGORY.RENT.fgcolor,
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.red, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            "Limit Reached",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight(500),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        ),
      ],
    );
  }
}
