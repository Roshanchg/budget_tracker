import 'package:flutter/material.dart';
import 'package:serene/Enums/category.dart';
import 'package:serene/Enums/currency.dart';
import 'package:serene/SomeConstants.dart';
import 'package:serene/classes/Budgets.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/sessionManagement.dart';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});
  @override
  State<AddBudgetPage> createState() => _AddBudgetPageState();
}

class _AddBudgetPageState extends State<AddBudgetPage> {
  CATEGORY selectedCategory = CATEGORY.FOOD;
  double? _budgetAmount;
  String? _nameValue;
  TextEditingController _nameInputController = TextEditingController();
  TextEditingController _budgetAmountInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _budgetIsAvailable() async {
    double totalBudget = await DatabaseHelper().getTotalBudgetAmountById(
      SessionStorage.instance.income!.id!,
    );
    double avialableBudget =
        SessionStorage.instance.income!.amount - totalBudget;
    if (_budgetAmount != null) {
      if (avialableBudget < _budgetAmount!) {
        _showError(
          context,
          "Budget Amount exceeds available money for allocation.",
        );
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<bool> _isValidInputs() async {
    try {
      double val = double.parse(_budgetAmountInputController.text);
      setState(() {
        _budgetAmount = val;
      });
    } catch (e) {
      _showError(context, "Invalid Budget amount.");
      return false;
    }
    setState(() {
      _nameValue = _nameInputController.text;
    });
    if (!await _budgetIsAvailable()) {
      return false;
    }
    return true;
  }

  String _getname() {
    if (_nameValue == null) {
      return selectedCategory.asDbString;
    } else if (_nameValue!.isEmpty) {
      return selectedCategory.asDbString;
    } else {
      return _nameValue!;
    }
  }

  Future<void> _submitForm() async {
    Budgets budgets = Budgets(
      userId: SessionStorage.instance.user!.id!,
      incomeId: SessionStorage.instance.income!.id!,
      category: selectedCategory,
      amount: _budgetAmount!,
      name: _getname(),
    );

    await DatabaseHelper().addBudget(budgets);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text("Add Budget"),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.directional(
          top: 12,
          bottom: 12,
          start: 28,
          end: 28,
        ),
        child: ListView(
          children: [
            // color: Color(0x40E1D4FD)
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x40E1d4fd),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(43, 158, 158, 158),
                        width: 2,
                      ),
                    ),
                    color: null,
                    child: TextField(
                      controller: _nameInputController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "e.g. Rent Payment",
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Text("Choose Category Icon"),
                  const SizedBox(height: 8),
                  Container(
                    alignment: AlignmentGeometry.center,
                    decoration: BoxDecoration(
                      color: Color(0x40e1d4fd),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: GridView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(16),

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      children: [
                        _buildCategoryIcon(CATEGORY.FOOD),
                        _buildCategoryIcon(CATEGORY.GYM),
                        _buildCategoryIcon(CATEGORY.MISC),
                        _buildCategoryIcon(CATEGORY.RENT),
                        _buildCategoryIcon(CATEGORY.SAVINGS),
                        _buildCategoryIcon(CATEGORY.SHOPPING),
                        _buildCategoryIcon(CATEGORY.TRANSPORTATION),
                        _buildCategoryIcon(CATEGORY.MISC),
                      ],
                    ),
                  ),

                  const SizedBox(height: 38),
                  const Text("Monthly Budget Limit"),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0x40E1d4fd),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color.fromARGB(43, 158, 158, 158),
                        width: 2,
                      ),
                    ),
                    color: null,
                    child: TextField(
                      controller: _budgetAmountInputController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixText:
                            "${SessionStorage.instance.user!.currency.prettyName} ",
                        border: InputBorder.none,
                        prefixStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        hintText: "0.00",
                        contentPadding: EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: null,
              decoration: BoxDecoration(color: Colors.white),
              width: context.widthPercentage(85),
              padding: EdgeInsets.all(14),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: PURPLEFOREGROUND,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    width: context.widthPercentage(75),
                    child: TextButton(
                      onPressed: () async {
                        if (await _isValidInputs()) {
                          _submitForm();

                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text(
                        "Create Budget",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text("Discard & Return"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(CATEGORY category) {
    IconData iconData = category.icon;
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: (selectedCategory == category) ? PURPLEBACKGROUND : Colors.white,
      ),
      child: IconButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        icon: Icon(iconData, color: Colors.black),
      ),
    );
  }
}
