import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serene/Enums/month.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/pages/subPages/addBudgetPage.dart';
import 'package:serene/pages/subPages/addExpensesPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> monthIncome = [12000, 13000, 13000, 13500, 17000];
  List<MONTH> months = [];
  List<FlSpot> spots = [];
  MONTH currentMonth = MONTH.JANUARY;
  int _monthFirst = 1;
  int _monthLast = 5;

  @override
  void initState() {
    super.initState();
    spots = monthIncome.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();
    currentMonth = MONTH.APRIL;
    _monthLast = currentMonth.number;
    if (_monthLast - 5 < 0) {
      _monthFirst = 13 - (5 - _monthLast);
    } else {
      _monthFirst = (_monthLast - 5) + 1;
    }

    for (int i = 0; i < 6; i++) {
      int numb = _monthFirst + i;
      if (numb > 12) {
        numb = numb - 12;
      }
      months.add(numb.month);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Container(
          color: null,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsetsGeometry.directional(
            start: 20,
            end: 20,
            top: 20,
            bottom: 30,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Income",
                          style: TextStyle(fontWeight: FontWeight(450)),
                        ),
                        Text(
                          "Rs. 1000000.87",
                          style: TextStyle(
                            fontWeight: FontWeight(700),
                            fontSize: 20,
                            color: PURPLEFOREGROUND,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: null,
                    padding: EdgeInsetsGeometry.directional(
                      start: 8,
                      end: 8,
                      top: 2,
                      bottom: 2,
                    ),
                    decoration: BoxDecoration(
                      color: GREENBACKGROUND,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "+2.5%",
                      style: TextStyle(color: GREENFOREGROUND),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Color(0xffF8F2FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsetsGeometry.directional(
                  start: 12,
                  end: 28,
                  top: 28,
                  bottom: 12,
                ),
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: 5000,
                      drawVerticalLine: false,
                      drawHorizontalLine: true,
                    ),
                    titlesData: FlTitlesData(
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${(value / 1000).toInt()}k',
                              style: TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        barWidth: 3,
                        color: PURPLEFOREGROUND,

                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, index, barData, context) {
                            // Only show dot on the last point (index == spots.length - 1)
                            if (index == spots.length - 1) {
                              return FlDotCirclePainter(
                                radius: 5,
                                color: PURPLEFOREGROUND,
                                strokeWidth: 2,
                                strokeColor: Colors.white,
                              );
                            }
                            // Hide all other dots
                            return FlDotCirclePainter(
                              radius: 0,
                            ); // or use FlDotPainter.simple(radius: 0)
                          },
                        ),
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          child: Column(
            children: [
              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsetsGeometry.directional(
                  start: 24,
                  end: 30,
                  top: 20,
                  bottom: 20,
                ),

                child: Row(
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: GREENBACKGROUND,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(12),
                      child: const Icon(
                        Icons.south_west,
                        color: GREENFOREGROUND,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Monthly Income"),
                          Text(
                            "Rs. 5400",
                            style: TextStyle(
                              fontWeight: FontWeight(600),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsetsGeometry.directional(
                  start: 24,
                  end: 30,
                  top: 20,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: REDBACKGROUND,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(12),
                      child: const Icon(Icons.north_east, color: REDFOREGROUND),
                    ),
                    const SizedBox(width: 20),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Monthly Expenses"),
                          Text(
                            "Rs. 5400",
                            style: TextStyle(
                              fontWeight: FontWeight(600),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsetsGeometry.directional(
                  start: 24,
                  end: 30,
                  top: 20,
                  bottom: 20,
                ),
                child: Row(
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: PURPLEBACKGROUND,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: EdgeInsets.all(12),
                      child: const Icon(
                        Icons.account_balance,
                        color: PURPLEFOREGROUND,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Disposable"),
                          Text(
                            "Rs. 5400",
                            style: TextStyle(
                              fontWeight: FontWeight(600),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Actions",
                style: TextStyle(fontWeight: FontWeight(450), fontSize: 20),
              ),
              const SizedBox(height: 20),
              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: EdgeInsetsGeometry.directional(
                  start: 16,
                  end: 0,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: PURPLEBACKGROUND,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(6),
                      child: const Icon(
                        Icons.add_card,
                        color: PURPLEFOREGROUND,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: const Text(
                        "Add Expenses",
                        style: TextStyle(fontWeight: FontWeight(600)),
                      ),
                    ),
                    IconButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddExpensePage(),
                          ),
                        ),
                      },
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: EdgeInsetsGeometry.directional(
                  start: 16,
                  end: 0,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: YELLOWBACKGROUND,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(6),
                      child: const Icon(
                        Icons.trending_up,
                        color: YELLOWFOREGROUND,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: const Text(
                        "Allocate Budget",
                        style: TextStyle(fontWeight: FontWeight(600)),
                      ),
                    ),
                    IconButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddBudgetPage(),
                          ),
                        ),
                      },
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                padding: EdgeInsetsGeometry.directional(
                  start: 16,
                  end: 0,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: PURPLEBACKGROUND,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(6),
                      child: const Icon(Icons.print, color: PURPLEFOREGROUND),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: const Text(
                        "Export Report",
                        style: TextStyle(fontWeight: FontWeight(600)),
                      ),
                    ),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
