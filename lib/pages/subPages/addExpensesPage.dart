import 'package:flutter/material.dart';
import 'package:serene/Enums/category.dart';
import 'package:serene/Enums/month.dart';
import 'package:serene/SomeConstants.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});
  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  DateTime? _pickedDate;
  TextEditingController _incomeInputController = TextEditingController();
  TimeOfDay? _pickedTime;

  CATEGORY selectedCategory = CATEGORY.MISC;

  @override
  void initState() {
    super.initState();
    selectedCategory = CATEGORY.MISC;
  }

  Future<void> _pickDateTime(BuildContext context) async {
    DateTime? _pd = await showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    TimeOfDay? _pt;
    if (_pd != null) {
      _pt = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }

    setState(() {
      _pickedDate = _pd;
      _pickedTime = _pt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context,true);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text("Add Expense"),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          children: [
            Container(
              color: null,
              decoration: BoxDecoration(
                color: Colors.white,
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
                  const Text(
                    "Available Balance",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rs. 10000",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight(500),
                      color: PURPLEFOREGROUND,
                    ),
                  ),
                  const SizedBox(height: 8),

                  LinearProgressIndicator(
                    value: .6,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Rs.", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 20),
                  Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(hintText: "00.00"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              color: null,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Category"),
                  const SizedBox(height: 12),
                  Container(
                    height: 36,

                    child: ListView.builder(
                      itemCount: CATEGORY.values.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              padding: EdgeInsetsGeometry.directional(
                                start: 10,
                                end: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (selectedCategory == CATEGORY.values[index])
                                    ? PURPLEFOREGROUND
                                    : Color(0x40e1d4fd),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = CATEGORY.values[index];
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      CATEGORY.values[index].displayName,
                                      style: TextStyle(
                                        color:
                                            (selectedCategory ==
                                                CATEGORY.values[index])
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      CATEGORY.values[index].icon,
                                      size: 18,
                                      color:
                                          (selectedCategory ==
                                              CATEGORY.values[index])
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 14),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
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
                                  _pickDateTime(context);
                                },
                                child: Text("Select a date"),
                              )
                            : TextButton(
                                onPressed: () {
                                  _pickDateTime(context);
                                },
                                child: Text(
                                  "${NumberToMonth(_pickedDate!.month).month.prettyName} ${_pickedDate!.year} ${_pickedTime!.hour}:${_pickedTime!.minute}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight(400),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Note"),
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
                      borderRadius: BorderRadius.circular(8),
                      border: BoxBorder.all(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.note_alt_outlined,
                          color: Color.fromARGB(255, 82, 82, 82),
                        ),
                        SizedBox(width: 12),
                        Container(
                          height: 50,
                          width: context.widthPercentage(60),
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Note...",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              width: context.widthPercentage(80),
              color: null,
              decoration: BoxDecoration(
                color: PURPLEFOREGROUND,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Save Expense",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(context,true);
              },
              child: const Text("Discard and Return"),
            ),
          ],
        ),
      ),
    );
  }
}
