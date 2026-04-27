import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text("Total Income"),
                        Text("Rs. 1000000.87"),
                      ],
                    ),
                  ),
                  SizedBox(child: Text("+2.5%")),
                ],
              ),
            ],
          ),
        ),

        Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(0),
                child: Row(
                  children: [
                    Icon(Icons.south_west),
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Monthly Income"),
                          Text("Rs. 5400"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.all(0),
                child: Row(
                  children: [
                    Icon(Icons.north_east),
                    Expanded(
                      child: Column(
                        children: [
                          const Text("Monthly Expenses"),
                          Text("Rs. 5400"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.all(0),
                child: Row(
                  children: [
                    Icon(Icons.account_balance),
                    Expanded(
                      child: Column(
                        children: [const Text("Disposable"), Text("Rs. 5400")],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            children: [
              const Text("Actions"),

              Padding(
                padding: EdgeInsetsGeometry.all(0),
                child: Row(
                  children: [
                    Icon(Icons.add_card),
                    SizedBox(width: 20),
                    Expanded(child: const Text("Add Expenses")),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.all(0),
                child: Row(
                  children: [
                    Icon(Icons.trending_up),
                    SizedBox(width: 20),
                    Expanded(child: const Text("Allocate Budget")),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.all(0),
                child: Row(
                  children: [
                    Icon(Icons.print),
                    SizedBox(width: 20),
                    Expanded(child: const Text("Export Report")),
                    IconButton(
                      onPressed: () => {},
                      icon: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
