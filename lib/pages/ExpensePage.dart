import 'package:flutter/material.dart';
import 'package:serene/Enums/category.dart';
import 'package:serene/SomeConstants.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});
  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Container(
          child: Row(
            children: [
              Column(
                children: [
                  const Text("Total Spent this month"),
                  Text("Rs. 5400.80"),
                ],
              ),
              Text("+12%"),
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
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xffECE6EE),
                      ),
                      child: const Text("All"),
                    ),
                    SizedBox(width: 10),
                  ],
                );
              }
              return Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xffECE6EE),
                    ),
                    child: Text(CATEGORY.values[index - 1].displayName),
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
              children: [
                const Text("Recent Expenses"),
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
