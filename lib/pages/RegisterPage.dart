import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:serene/Authenticator.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/Session.dart';
import 'package:serene/classes/User.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/pages/LoginPage.dart';
import 'package:serene/pages/RootPage.dart';
import 'package:serene/sessionManagement.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                    icon: Icon(Icons.fingerprint, color: Colors.grey),
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
                    await Authenticator.register(int.parse(_pin));
                    if (await SessionManagement.sessionExists()) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RootPage()),
                      );
                    }
                  } catch (e) {
                    log("Parsing Error: $e");
                  }
                },

                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: const Text(
                  "Create PIN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text("Know PIN? Log in"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createNewRootUser(int pin) async {
    User newUser = User(name: "Root User", pin: pin);
    final int id = await DatabaseHelper().addUser(newUser);
    if (id >= 0) {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      Session newSession = Session(id: id, userId: id, date: today);
      int sessionId = await DatabaseHelper().addSession(newSession);
      if (sessionId >= 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RootPage()),
        );
      }
    }
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
