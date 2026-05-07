import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:serene/Authenticator.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/helpers.dart';
import 'package:serene/pages/RegisterPage.dart';
import 'package:serene/pages/RootPage.dart';
import 'package:serene/sessionManagement.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPinMode = true;
  int _insertedPinCount = 0;
  final int _totalPinCount = 4;
  String _pin = "";
  @override
  void initState() {
    _isPinMode = true;
    _pin = "";
    _insertedPinCount = _pin.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 30),
      body: Container(
        alignment: AlignmentGeometry.center,
        padding: EdgeInsetsGeometry.directional(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsetsGeometry.all(14),
              color: null,
              decoration: BoxDecoration(
                color: PURPLEFOREGROUND,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.wallet, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 12),
            const Text(
              "Serene Finance",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight(550)),
            ),
            const Text("Your Budgeting Application"),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsetsGeometry.directional(start: 4, end: 4),
                  color: null,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(80, 186, 186, 186),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: (_isPinMode)
                              ? Colors.white
                              : Colors.transparent,
                          padding: EdgeInsetsGeometry.directional(
                            start: 40,
                            end: 40,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPinMode = true;
                          });
                        },
                        child: Text(
                          "PIN Code",
                          style: TextStyle(
                            color: (_isPinMode)
                                ? Color(0xff4F378A)
                                : Color(0xff7A7582),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: (_isPinMode)
                              ? Colors.transparent
                              : Colors.white,
                          padding: EdgeInsetsGeometry.directional(
                            start: 40,
                            end: 40,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPinMode = false;
                          });
                        },
                        child: Text(
                          "Fingerprint",
                          style: TextStyle(
                            color: (!_isPinMode)
                                ? Color(0xff4F378A)
                                : Color(0xff7A7582),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // PIN CIRCLES
            Container(
              height: 80,
              width: 100,
              alignment: AlignmentGeometry.center,
              decoration: BoxDecoration(),
              child: ListView.builder(
                itemCount: _totalPinCount,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Container(
                    color: null,
                    width: 16,
                    height: 16,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: (index < _insertedPinCount)
                          ? PURPLEFOREGROUND
                          : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),

            // DIAL PAD
            Container(
              alignment: AlignmentGeometry.center,
              width: context.widthPercentage(80),
              child: GridView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 20,
                  crossAxisCount: 3,
                  childAspectRatio: 1.2,
                ),
                children: [
                  _buildDialTextButton("1"),
                  _buildDialTextButton("2"),
                  _buildDialTextButton("3"),
                  _buildDialTextButton("4"),
                  _buildDialTextButton("5"),
                  _buildDialTextButton("6"),
                  _buildDialTextButton("7"),
                  _buildDialTextButton("8"),
                  _buildDialTextButton("9"),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.fingerprint, color: PURPLEFOREGROUND),
                  ),
                  _buildDialTextButton("0"),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_pin.isNotEmpty) {
                          _pin = _pin.substring(0, _pin.length - 1);
                          _insertedPinCount = _pin.length;
                        }
                      });
                    },
                    icon: Icon(Icons.backspace, color: Colors.grey),
                  ),
                ],
              ),
            ),

            Container(
              color: null,
              width: context.widthPercentage(80),
              decoration: BoxDecoration(
                color: PURPLEFOREGROUND,
                borderRadius: BorderRadius.circular(12),
              ),
              height: 54,
              child: TextButton(
                onPressed: () async {
                  try {
                    if (await Authenticator.login(int.parse(_pin))) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RootPage()),
                      );
                    } else {
                      Helpers.showSnackbar(context, "Invalid PIN");
                    }
                  } catch (e) {
                    log("Parsing error login page: $e");
                    Helpers.showSnackbar(context, "Invalid PIN");
                  }
                },

                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  "Unlock Vault",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: const Text("Forgot Pin? Reset"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialTextButton(String number) {
    return TextButton(
      onPressed: () {
        setState(() {
          if (_pin.length < 4) {
            _pin += number;
            _insertedPinCount = _pin.length;
          }
        });
      },
      child: Text(
        number,
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight(500),
          color: Colors.black,
        ),
      ),
    );
  }
}
