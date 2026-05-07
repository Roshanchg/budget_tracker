import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serene/Enums/month.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/Income.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/pages/subPages/addBudgetPage.dart';
import 'package:serene/pages/subPages/addExpensesPage.dart';
import 'package:serene/sessionManagement.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> _monthIncome = [];
  List<Income> _recentIncomes = [];
  List<int> _monthsNum = [];
  List<FlSpot> _spots = [];

  bool _hasIncome = false;
  double? _incomeValue;
  double? _totalExpenses;
  double? _disposal;
  double? _incomeIncrease;

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      await _dataStates();
    });
  }

  void _showOldIncomeDialogueBox() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            height: 100,
            child: Column(
              children: [Text("Old Income Exists from month. APRIL")],
            ),
          ),
        );
      },
    );
  }

  Future<void> _dataStates() async {
    if (SessionStorage.instance.income == null) {
      setState(() {
        _hasIncome = false;
      });
    } else {
      _totalExpenses = await DatabaseHelper().getTotalExpenseAmount(
        SessionStorage.instance.income!.id!,
      );

      setState(() {
        _totalExpenses ??= 0;
        _hasIncome = true;
        _incomeValue = SessionStorage.instance.income!.amount;
      });
    }
    if (_hasIncome) {
      _recentIncomes = await DatabaseHelper().getFiveIncomesByUserId(
        SessionStorage.instance.user!.id!,
      );
      setState(() {
        _monthIncome = _recentIncomes.map((item) => item.amount).toList();

        _monthsNum = _recentIncomes
            .map((item) => item.dateAdded.month)
            .toList()
            .reversed
            .toList();

        for (var i = 1; i <= _monthIncome.length; i++) {
          _spots.add(
            FlSpot(i - 1.toDouble(), _monthIncome[_monthIncome.length - i]),
          );
        }
        log(_spots.toString());
      });
      if (_totalExpenses != null) {
        setState(() {
          _disposal = _incomeValue! - _totalExpenses!;
        });
      }
      if (_monthsNum.length > 1) {
        setState(() {
          double lastMonthIncome = _monthIncome[1];
          double currentMonthIncome = _monthIncome[0];
          double incomeDiff = currentMonthIncome - lastMonthIncome;
          _incomeIncrease = incomeDiff * 100 / lastMonthIncome;
        });
      } else {
        setState(() {
          _incomeIncrease = 0.0;
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (!_hasIncome)
        ? Center(child: Text("No Income added!!"))
        : ListView(
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
                                "Rs.${_incomeValue.toString()}",
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
                            color:
                                ((_incomeIncrease != null) &&
                                    _incomeIncrease! < 0)
                                ? REDBACKGROUND
                                : GREENBACKGROUND,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: (_incomeIncrease == null)
                              ? Text("0.0")
                              : Text(
                                  "${_incomeIncrease!.toStringAsFixed(1)}%",

                                  style: TextStyle(
                                    color:
                                        ((_incomeIncrease != null) &&
                                            _incomeIncrease! < 0)
                                        ? REDFOREGROUND
                                        : GREENFOREGROUND,
                                  ),
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
                      child: (_spots.isEmpty)
                          ? null
                          : LineChart(
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
                                        int index = value.toInt();
                                        if (index >= 0 &&
                                            index < _monthsNum.length) {
                                          return Text(
                                            _monthsNum[index].month.chartName,
                                          );
                                        } else {
                                          return Text("");
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: _spots,
                                    isCurved: true,
                                    barWidth: 3,
                                    color: PURPLEFOREGROUND,

                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, index, barData, context) {
                                            return FlDotCirclePainter(
                                              radius: 0,
                                            );
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
                                  "Rs.${_incomeValue.toString()}",
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
                            child: const Icon(
                              Icons.north_east,
                              color: REDFOREGROUND,
                            ),
                          ),
                          const SizedBox(width: 20),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Monthly Expenses"),
                                Text(
                                  "Rs.${_totalExpenses.toString()}",
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
                                  "Rs.${_disposal.toString()}",
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
                      style: TextStyle(
                        fontWeight: FontWeight(450),
                        fontSize: 20,
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
                            child: const Icon(
                              Icons.print,
                              color: PURPLEFOREGROUND,
                            ),
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
