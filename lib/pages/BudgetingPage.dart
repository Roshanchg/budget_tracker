import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:serene/Enums/category.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/Budgets.dart';
import 'package:serene/classes/Income.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/pages/RootPage.dart';
import 'package:serene/sessionManagement.dart';

class BudgetingPage extends StatefulWidget {
  const BudgetingPage({super.key});
  @override
  State<BudgetingPage> createState() => _BudgetingPageState();
}

class _BudgetingPageState extends State<BudgetingPage> {
  bool _isLoading = true;
  bool _incomeExists = false;
  bool _dataExists = false;
  double? _totalBudget;
  List<Budgets> _allBudgets = [];

  @override
  void initState() {
    super.initState();
    _loadBudgetData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navBack();
    });
  }

  void _navBack() {
    if (SessionStorage.instance.income != null) {
      setState(() {
        _incomeExists = true;
      });
    }
    if (!_incomeExists) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
      );
    }
  }

  Future<void> _loadBudgetData() async {
    setState(() {
      _isLoading = true;
      _dataExists = false;
    });
    Income? income = SessionStorage.instance.income;
    if (income == null) {
      setState(() {
        _incomeExists = false;
      });
      return;
    }
    try {
      _allBudgets = await DatabaseHelper().getBudgetsByIncomeId(income.id!);
      if (_allBudgets.isEmpty) {
        setState(() {
          _isLoading = false;
          _dataExists = false;
        });
      } else {
        _totalBudget = await DatabaseHelper().getTotalBudgetAmountById(
          SessionStorage.instance.income!.id!,
        );

        setState(() {
          _isLoading = false;
          _dataExists = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _dataExists = false;
      });
      return;
    }
  }

  List<PieChartSectionData> _getPieChartData() {
    List<PieChartSectionData> allChartData = _allBudgets.map((item) {
      return PieChartSectionData(
        value: item.amount,
        color: item.category.fgcolor,
        radius: 20,
        showTitle: false,
      );
    }).toList();

    return allChartData;
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(child: CircularProgressIndicator())
        : (!_dataExists)
        ? Center(
            child: Text(
              "Budgets Not allocated!!.\nPress the floating button to add one.",
              textAlign: TextAlign.center,
            ),
          )
        : ListView(
            padding: EdgeInsetsGeometry.directional(
              start: 20,
              top: 20,
              end: 20,
            ),
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
                              sections: _getPieChartData(),
                              sectionsSpace: 0,
                              centerSpaceRadius: 70,
                            ),
                          ),
                        ),

                        Column(
                          children: [
                            const Text(
                              "Total Allocated",
                              style: TextStyle(fontWeight: FontWeight(400)),
                            ),
                            Text(
                              "${_totalBudget.toString()}",
                              style: TextStyle(
                                fontWeight: FontWeight(700),
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "of Rs.${SessionStorage.instance.income!.amount.toString()}",
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
                    _buildGridPane(),
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
                      child: Row(
                        children: [Icon(Icons.add), Text("New Category")],
                      ),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _allBudgets.length,
                itemBuilder: (context, index) {
                  Budgets _budget = _allBudgets[index];
                  double _progressValue =
                      1 -
                      (SessionStorage.instance.income!.amount -
                              _budget.amount) /
                          SessionStorage.instance.income!.amount;
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
                                    color: _budget.category.bgcolor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.all(8),

                                  child: Icon(
                                    _budget.category.icon,
                                    color: _budget.category.fgcolor,
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
                                      _budget.category.displayName,
                                      style: TextStyle(
                                        fontWeight: FontWeight(500),
                                      ),
                                    ),
                                    Text(
                                      "Rs.${_budget.amount.toString()}",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight(500),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "of Rs.${SessionStorage.instance.income!.amount.toString()} ",
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(8),
                              minHeight: 8,
                              value: _progressValue,
                              color: CATEGORY.RENT.fgcolor,
                            ),
                            SizedBox(height: 20),

                            Row(
                              children: [
                                Icon(Icons.info, color: Colors.red, size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  "Note: ${_budget.name}",
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

  Widget _buildGridPane() {
    return Padding(
      padding: EdgeInsetsGeometry.directional(
        top: 20,
        start: 20,
        end: 20,
        bottom: 12,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 5,
          mainAxisSpacing: 4,
          crossAxisSpacing: 8,
        ),
        itemCount: _allBudgets.length,
        itemBuilder: (context, index) {
          return Container(
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _allBudgets[index].category.fgcolor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(width: 10),
                Text("${_allBudgets[index].category.displayName}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
