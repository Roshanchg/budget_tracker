import 'package:flutter/material.dart';
import 'package:serene/Enums/currency.dart';
import 'package:serene/Enums/month.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/Income.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/sessionManagement.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({super.key});

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  DateTime? _pickedDate;
  TextEditingController _incomeInputController = TextEditingController();
  double? _enteredIncomeAmount;
  bool _isValidInputs = false;
  Future<void> _pickDate(BuildContext context) async {
    DateTime? _pd = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    setState(() {
      _pickedDate = _pd;
    });
    _validateIncomeField();
  }

  @override
  void initState() {
    super.initState();
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateIncomeField() {
    try {
      List<String> parts = _incomeInputController.text.split(".");
      if (parts.length > 2) {
        return false;
      }
      if (parts.isEmpty) {
        return false;
      }
      double value = double.parse(_incomeInputController.text);
      _enteredIncomeAmount = value;

      return true;
    } catch (e) {
      _incomeInputController.text = "";
      _enteredIncomeAmount = null;
      return false;
    }
  }

  void _validateInputValues() {
    if (_pickedDate != null && _validateIncomeField()) {
      setState(() {
        _isValidInputs = true;
      });
    } else {
      setState(() {
        _isValidInputs = false;
      });
    }
  }

  Future<void> _onSubmit() async {
    _validateInputValues();
    if (_enteredIncomeAmount == null) return;
    if (!_isValidInputs) {
      _showError(context, "Invalid Input Fields");
      return;
    }
    Income newIncome = Income(
      userId: SessionStorage.instance.user!.id!,
      amount: _enteredIncomeAmount!,
      dateAdded: _pickedDate!,
    );
    DatabaseHelper().addIncome(newIncome);
    SessionStorage.instance.income = await DatabaseHelper().getIncomeByUserId(
      SessionStorage.instance.user!.id!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (mounted) {
              Navigator.pop(context, true);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Add Monthly Income"),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.directional(
          top: 30,
          start: 20,
          end: 20,
          bottom: 0,
        ),
        child: ListView(
          children: [
            Container(
              color: null,
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    "Amount Received",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight(400)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: null,
                        decoration: BoxDecoration(
                          color: const Color(0x5BE1D4FD),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0x429E9E9E),
                            width: 2,
                          ),
                        ),
                        padding: EdgeInsetsGeometry.directional(
                          start: 20,
                          end: 20,
                          top: 8,
                          bottom: 8,
                        ),

                        child: Text(CURRENCY.NRP.name),
                      ),
                      const SizedBox(width: 20),
                      Container(
                        width: 120,
                        height: 40,
                        child: TextField(
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          controller: _incomeInputController,
                          onEditingComplete: () => _validateInputValues(),
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            focusColor: Colors.transparent,
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Category"),
                      const SizedBox(height: 8),
                      Container(
                        color: null,
                        padding: EdgeInsetsGeometry.directional(
                          top: 10,
                          bottom: 10,
                          start: 14,
                          end: 14,
                        ),
                        decoration: BoxDecoration(
                          color: PURPLEBACKGROUND,
                          border: Border.all(color: PURPLEFOREGROUND, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.money, color: PURPLEFOREGROUND),
                            SizedBox(width: 12),
                            Text("Salary", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pay Period"),
                      const SizedBox(height: 8),
                      Container(
                        color: null,
                        padding: EdgeInsetsGeometry.directional(
                          top: 10,
                          bottom: 10,
                          start: 14,
                          end: 14,
                        ),
                        decoration: BoxDecoration(
                          color: PURPLEBACKGROUND,
                          border: Border.all(color: PURPLEFOREGROUND, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month, color: PURPLEFOREGROUND),
                            SizedBox(width: 12),
                            Text("Monthly", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Date"),
                      const SizedBox(height: 8),
                      Container(
                        color: null,
                        padding: EdgeInsetsGeometry.directional(
                          top: 0,
                          bottom: 0,
                          start: 18,
                          end: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0x40E1D4FD),
                          borderRadius: BorderRadius.circular(8),
                          border: BoxBorder.all(
                            color: const Color.fromARGB(255, 221, 221, 221),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: const Color.fromARGB(255, 82, 82, 82),
                              size: 20,
                            ),
                            (_pickedDate == null)
                                ? TextButton(
                                    onPressed: () {
                                      _pickDate(context);
                                    },
                                    child: Text("Select a date"),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      _pickDate(context);
                                    },
                                    child: Text(
                                      "${NumberToMonth(_pickedDate!.month).month.prettyName} ${_pickedDate!.year}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight(400),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PURPLEFOREGROUND,
                    ),
                    onPressed: () async {
                      _onSubmit();
                      Navigator.pop(context, true);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Save Income",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: context.widthPercentage(80),
              decoration: BoxDecoration(
                border: Border.all(color: PURPLEBACKGROUND, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.pop(context, false);
                  }
                },
                child: const Text("Cancel and Discard"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
