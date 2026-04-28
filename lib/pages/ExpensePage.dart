import 'package:flutter/material.dart';
import 'package:serene/Enums/category.dart';
import 'package:serene/SomeConstants.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});
  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  int _activeFilterIndex = 0;

  @override
  void initState() {}

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
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Spent this month"),
                  Text(
                    "Rs. 5400.80",
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
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsetsGeometry.directional(
                  start: 10,
                  end: 10,
                  top: 4,
                  bottom: 4,
                ),
                child: Text(
                  "+ 12%",
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
                  style: TextStyle(fontWeight: FontWeight(500), fontSize: 20),
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
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today Apr 27"),
                      SizedBox(height: 8),
                      SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (index == 0) ? 2 : 3,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsetsGeometry.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsetsGeometry.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
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
                                              "Whole Food",
                                              style: TextStyle(
                                                fontWeight: FontWeight(600),
                                              ),
                                            ),
                                            Text(
                                              "Food and Grocerries",
                                              style: TextStyle(
                                                color: Color(0x80000000),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        "-Rs.1000",
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
