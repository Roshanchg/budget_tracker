import 'package:flutter/material.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/pages/BudgetingPage.dart';
import 'package:serene/pages/ExpensePage.dart';
import 'package:serene/pages/HomePage.dart';
import 'package:serene/pages/SettingsPage.dart';
import 'package:serene/pages/subPages/addBudgetPage.dart';
import 'package:serene/pages/subPages/addExpensesPage.dart';
import 'package:serene/pages/subPages/addIncomePage.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final List<Widget> pages = [
    HomePage(),
    ExpensePage(),
    BudgetingPage(),
    SettingsPage(),
  ];
  final List<StatefulWidget> subPages = [
    AddIncomePage(),
    AddExpensePage(),
    AddBudgetPage(),
  ];
  int _currentActiveIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      bottomNavigationBar: getBottomNavBar(
        _currentActiveIndex = _currentActiveIndex,
        (index) => setState(() {
          _currentActiveIndex = index;
        }),
      ),

      body: pages[_currentActiveIndex],
      floatingActionButton: (_currentActiveIndex == 3)
          ? null
          : IconButton(
              style: IconButton.styleFrom(
                backgroundColor: PRIMARYCOLOR,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => subPages[_currentActiveIndex],
                  ),
                ),
              },
              icon: Icon(Icons.add),
            ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: APPBAR_BACKGROUNDCOLOR,
      leading: Icon(Icons.wallet_outlined, color: PRIMARYCOLOR, size: 30),
      title: Text(
        APPNAME,
        style: TextStyle(color: PRIMARYCOLOR, fontWeight: FontWeight(500)),
      ),
      actions: [
        IconButton(
          onPressed: () => {
            setState(() {
              _currentActiveIndex = 3;
            }),
          },
          icon: Icon(Icons.person_2_sharp, color: PRIMARYCOLOR),
        ),
      ],
    );
  }

  BottomNavigationBar getBottomNavBar(
    int currentActiveIndex,
    ValueChanged<int> onTabChanged,
  ) {
    return BottomNavigationBar(
      onTap: (value) => {onTabChanged(value)},
      currentIndex: currentActiveIndex,
      backgroundColor: Colors.white,
      selectedItemColor: PRIMARYCOLOR,
      unselectedItemColor: BOTTOMBAR_UNSELECTEDCOLOR,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: "Expenses",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_outline),
          label: "Budget",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
        ),
      ],
    );
  }
}
