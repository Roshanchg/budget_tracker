import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/User.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/pages/BudgetingPage.dart';
import 'package:serene/pages/ExpensePage.dart';
import 'package:serene/pages/HomePage.dart';
import 'package:serene/pages/LoginPage.dart';
import 'package:serene/pages/RegisterPage.dart';
import 'package:serene/pages/SettingsPage.dart';
import 'package:serene/pages/subPages/addBudgetPage.dart';
import 'package:serene/pages/subPages/addExpensesPage.dart';
import 'package:serene/pages/subPages/addIncomePage.dart';
import 'package:serene/sessionManagement.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _isLoading = true;

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
  void initState() {
    super.initState();
    _checkForLogin();
  }

  Future<void> _checkForLogin() async {
    setState(() {
      _isLoading = true;
    });
    if (!await SessionManagement.sessionExists()) {
      User? user = await DatabaseHelper().getUserById(0);
      setState(() {
        _isLoading = false;
      });
      if (user == null) {
        log("User doesnot exist");
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        }
      } else {
        log("User not logged in");
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
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
                    onPressed: () async {
                      final bool? shouldRefresh = await (Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => subPages[_currentActiveIndex],
                        ),
                      ));
                      if (shouldRefresh == null || shouldRefresh) {
                        await _checkForLogin();
                        setState(() {});
                      }
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
