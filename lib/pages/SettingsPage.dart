import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:serene/Enums/currency.dart';
import 'package:serene/Exporter.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/User.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/helpers.dart';
import 'package:serene/pages/LoginPage.dart';
import 'package:serene/pages/RegisterPage.dart';
import 'package:serene/pages/RootPage.dart';
import 'package:serene/sessionManagement.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _nameController = TextEditingController();
  CURRENCY _selectedCurrency = CURRENCY.NRP;
  String _currentName = "No Name";
  bool _biometricToggle = false;
  String _firstName = "";
  String _lastName = "";
  User? _user;

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _getValues();
  }

  Future<void> _getValues() async {
    _user = SessionStorage.instance.user;

    if (_user != null) {
      setState(() {
        _currentName = _user!.name;
        _biometricToggle = _user!.biometric;
        _firstName = _currentName.split(" ")[0];
        _lastName = _currentName.split(" ").sublist(1).join(" ");
        _isLoading = false;
        _nameController.text = _currentName;
        _selectedCurrency = _user!.currency;
      });
    }
  }

  Future<void> changeName() async {
    setState(() {
      _currentName = _nameController.text;
      _firstName = _currentName.split(" ")[0];
      _lastName = _currentName.split(" ").sublist(1).join(" ");
    });
    User newUser = User(
      pin: _user!.pin,
      name: _nameController.text,
      biometric: _user!.biometric,
      currency: _user!.currency,
    );
    await DatabaseHelper().updateUser(newUser);

    SessionStorage.instance.user = newUser;
    await _getValues();
  }

  Future<void> changeCurrency() async {
    User newUser = User(
      pin: _user!.pin,
      name: _user!.name,
      biometric: _user!.biometric,
      currency: _selectedCurrency,
    );
    await DatabaseHelper().updateUser(newUser);
    SessionStorage.instance.user = newUser;
    await _getValues();
  }

  Future<void> changeBiometric() async {
    setState(() {
      _biometricToggle = !_biometricToggle;
    });
    User newUser = User(
      pin: _user!.pin,
      name: _nameController.text,
      biometric: _biometricToggle,
      currency: _user!.currency,
    );

    await DatabaseHelper().updateUser(newUser);
    SessionStorage.instance.user = newUser;
    await _getValues();
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? Center(child: CircularProgressIndicator())
        : ListView(
            padding: EdgeInsetsGeometry.directional(
              start: 20,
              end: 20,
              top: 30,
              bottom: 0,
            ),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Settings",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight(600)),
                  ),
                  Text("Manage your account preferences"),
                ],
              ),
              const SizedBox(height: 20),
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
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          color: null,
                          decoration: BoxDecoration(
                            color: PURPLEBACKGROUND,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.person_2,
                            color: PURPLEFOREGROUND,
                            size: 50,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _firstName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight(500),
                              ),
                            ),
                            Text(
                              _lastName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight(500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Display Name"),
                        const SizedBox(height: 8),
                        Container(
                          color: null,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsetsGeometry.directional(
                            start: 16,
                            end: 16,
                            top: 4,
                            bottom: 4,
                          ),
                          child: TextField(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight(450),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            onEditingComplete: () {
                              changeName();
                              log(_currentName);
                            },
                            controller: _nameController,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Currency"),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsetsGeometry.directional(
                            start: 16,
                            end: 16,
                            top: 4,
                            bottom: 4,
                          ),
                          width: context.widthPercentage(100),
                          child: Row(
                            children: [
                              Expanded(
                                child: DropdownButton(
                                  underline: const SizedBox.shrink(),
                                  icon: const SizedBox.shrink(),
                                  value: _selectedCurrency,
                                  items: CURRENCY.values.toList().map((
                                    CURRENCY item,
                                  ) {
                                    return DropdownMenuItem<CURRENCY>(
                                      value: item,
                                      child: Container(
                                        child: Text(item.asDbString),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCurrency = value!;
                                    });
                                    changeCurrency();
                                  },
                                ),
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ],
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
                  start: 20,
                  end: 20,
                  top: 8,
                  bottom: 8,
                ),
                child: Row(
                  children: [
                    Icon(Icons.fingerprint, color: PURPLEFOREGROUND),
                    const SizedBox(width: 14),
                    const Expanded(child: Text("Biometric Unlock")),
                    Switch(
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.deepPurple[30],
                      trackOutlineColor: WidgetStatePropertyAll(
                        Colors.transparent,
                      ),
                      value: _biometricToggle,
                      onChanged: (value) {
                        changeBiometric();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Color(0x06ff0000),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsetsGeometry.directional(
                  top: 30,
                  bottom: 30,
                  start: 24,
                  end: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: REDBACKGROUND,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),

                      child: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Permanently delete all data from this device. Including user information.",
                    ),
                    const SizedBox(height: 20),

                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: context.widthPercentage(100),
                      height: 40,
                      child: TextButton(
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.red),
                                    const SizedBox(width: 10),
                                    Text(
                                      "Do you want to delete all data?",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await DatabaseHelper().removeDB();
                                      if (mounted) {
                                        Navigator.of(
                                          context,
                                        ).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterPage(),
                                          ),
                                          (Route<dynamic> route) => false,
                                        );
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: REDBACKGROUND,
                                    ),
                                    child: Text(
                                      "Yes, Delete it",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No, Go back"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          "Erase All Data",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                color: null,
                decoration: BoxDecoration(
                  color: Color.fromARGB(6, 115, 0, 255),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsetsGeometry.directional(
                  top: 30,
                  bottom: 30,
                  start: 24,
                  end: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: PURPLEBACKGROUND,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.all(8),

                      child: const Icon(Icons.print, color: PURPLEFOREGROUND),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Export all data into a csv or json file/s for offline review ",
                    ),
                    const SizedBox(height: 20),

                    Container(
                      color: null,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: context.widthPercentage(100),
                      height: 40,
                      child: TextButton(
                        onPressed: () async {
                          if (await CSVExporter.exportAll()) {
                            Helpers.showSnackbar(
                              context,
                              "Exported Successfully. Files are at your application storage.\n(Android/data/com.example.serene/files)",
                            );
                          } else {
                            Helpers.showSnackbar(context, "Export Failed !!!");
                          }
                        },
                        child: const Text(
                          "Export All Data",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                color: null,
                decoration: BoxDecoration(
                  border: Border.all(color: BLUEBACKGROUND, width: 1.5),
                  color: BLUEFOREGROUND,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () async {
                    await SessionManagement.endAllSessions();
                    if (mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
  }
}
