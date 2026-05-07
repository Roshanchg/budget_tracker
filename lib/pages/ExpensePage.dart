import 'package:flutter/material.dart';
import 'package:serene/Enums/category.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/Expense.dart';
import 'package:serene/classes/Income.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/helpers.dart';
import 'package:serene/pages/RootPage.dart';
import 'package:serene/sessionManagement.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});
  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  int _activeFilterIndex = 0;

  bool _isLoading = true;

  bool _expenseExists = false;

  Map<DateTime, List<Expense>> _expensesMap = {};

  double? _totalExpenses;

  @override
  void initState() {
    super.initState();
    _loadExpensesToMap();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToIncomePage();
    });
  }

  void _navigateToIncomePage() {
    if (SessionStorage.instance.income == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RootPage()),
      );
    }
  }

  Future<void> _loadExpensesToMap() async {
    setState(() {
      _isLoading = true;
    });
    Income? _income = SessionStorage.instance.income;
    if (_income == null) {
      setState(() {
        _isLoading = false;
        _expenseExists = true;
      });

      return;
    } else {
      List<Expense> expenses = await DatabaseHelper().getExpensesByIncomeId(
        _income.id!,
      );
      _totalExpenses = await DatabaseHelper().getTotalExpenseAmount(
        _income.id!,
      );
      for (var expense in expenses) {
        if (_expensesMap.containsKey(expense.dateTime)) {
          _expensesMap[expense.dateTime]!.add(expense);
        } else {
          _expensesMap[expense.dateTime] = [expense];
        }
      }
      if (_expensesMap.isNotEmpty) {
        setState(() {
          _isLoading = false;
          _expenseExists = true;
          return;
        });
      } else {
        setState(() {
          _isLoading = false;

          _expenseExists = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(child: CircularProgressIndicator())
        : (!_expenseExists)
        ? Center(
            child: Text(
              "No Expenses Added.\n Add some using the floating button.",
              textAlign: TextAlign.center,
            ),
          )
        : ListView(
            padding: EdgeInsets.all(20),
            children: [
              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Total Spent this month"),
                        Text(
                          "Rs.${_totalExpenses.toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight(600),
                            fontSize: 28,
                            color: PURPLEFOREGROUND,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsetsGeometry.directional(
                        start: 10,
                        end: 10,
                        top: 4,
                        bottom: 4,
                      ),
                      child: Text(
                        "",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight(700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                alignment: Alignment.topLeft,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: CATEGORY.values.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _activeFilterIndex = index;
                              });
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: (_activeFilterIndex == index)
                                  ? PURPLEFOREGROUND
                                  : Color(0xFFECE6EE),
                            ),
                            child: Text(
                              "All",
                              style: TextStyle(
                                color: (_activeFilterIndex == index)
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight(400),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _activeFilterIndex = index;
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: (_activeFilterIndex == index)
                                ? PURPLEFOREGROUND
                                : Color(0xFFECE6EE),
                          ),
                          child: Text(
                            CATEGORY.values[index - 1].displayName,
                            style: TextStyle(
                              color: (_activeFilterIndex == index)
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight(400),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    );
                  },
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Recent Expenses",
                        style: TextStyle(
                          fontWeight: FontWeight(500),
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("View Analysis"),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _expensesMap.keys.length,
                      itemBuilder: (context, index) {
                        DateTime dt = _expensesMap.keys.elementAt(index);
                        List<Expense>? expenses = _expensesMap[dt] ?? [];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${Helpers.prettyDateForExpenses(dt)}"),
                            SizedBox(height: 8),
                            SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  Expense ex = expenses[index];
                                  return Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: EdgeInsetsGeometry.all(16),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsetsGeometry.all(
                                                10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                color: GREENBACKGROUND,
                                              ),
                                              child: Icon(
                                                Icons.restaurant,
                                                color: GREENFOREGROUND,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${ex.note}",
                                                    style: TextStyle(
                                                      fontWeight: FontWeight(
                                                        600,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${ex.category.displayName}",
                                                    style: TextStyle(
                                                      color: Color(0x80000000),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "-Rs.${ex.amount.toString()}",
                                              style: TextStyle(
                                                fontWeight: FontWeight(600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
