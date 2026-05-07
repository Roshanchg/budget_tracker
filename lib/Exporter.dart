import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serene/classes/Budgets.dart';
import 'package:serene/classes/Expense.dart';
import 'package:serene/classes/Income.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/helpers.dart';

class CSVExporter {
  static Future<String> _convertToCSVString(
    List<Map<String, dynamic>> data,
  ) async {
    if (data.isEmpty) {
      throw Exception("No data to export");
    }

    List<String> headers = data.first.keys.toList();
    List<List<dynamic>> csvData = [];
    csvData.add(headers);

    for (var row in data) {
      List<dynamic> rowData = [];
      for (var header in headers) {
        rowData.add(row[header] ?? '');
      }
      csvData.add(rowData);
    }

    return const ListToCsvConverter().convert(csvData);
  }

  static Future<bool> _saveToFile(String csvString, String filename) async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir == null) {
        log("NULL external dir");
        return false;
      }
      File csvFile = File("${externalDir.path}/${filename}");
      await csvFile.writeAsString(csvString);
      log("File written at ${csvFile.path}");
      return true;
    } catch (e) {
      log("Failed to export: $e");
      return false;
    }
  }

  static Future<bool> exportAll() async {
    bool incomesSuccess = await exportIncomes();
    bool budgetsSuccess = await exportBudgets();
    bool expensesSuccess = await exportExpenses();

    return incomesSuccess || budgetsSuccess || expensesSuccess;
  }

  static Future<bool> exportIncomes() async {
    try {
      List<Income> incomes = await DatabaseHelper().getAllIncomes();
      List<Map<String, dynamic>> incomesMap = incomes
          .map((e) => e.toMap())
          .toList();

      String csvString = await _convertToCSVString(incomesMap);
      String filename = 'incomes_${DateTime.now().millisecondsSinceEpoch}.csv';

      return await _saveToFile(csvString, filename);
    } catch (e) {
      log("Failed to export incomes: $e");
      return false;
    }
  }

  static Future<bool> exportBudgets() async {
    try {
      List<Budgets> budgets = await DatabaseHelper().getAllBudgets();
      List<Map<String, dynamic>> budgetsMap = budgets
          .map((e) => e.toMap())
          .toList();

      String csvString = await _convertToCSVString(budgetsMap);
      String filename = 'budgets_${DateTime.now().millisecondsSinceEpoch}.csv';

      return await _saveToFile(csvString, filename);
    } catch (e) {
      log("Failed to export budgets: $e");
      return false;
    }
  }

  static Future<bool> exportExpenses() async {
    try {
      List<Expense> expenses = await DatabaseHelper().getAllExpenses();
      List<Map<String, dynamic>> expensesMap = expenses
          .map((e) => e.toMap())
          .toList();

      String csvString = await _convertToCSVString(expensesMap);
      String filename = 'expenses_${DateTime.now().millisecondsSinceEpoch}.csv';

      return await _saveToFile(csvString, filename);
    } catch (e) {
      log("Failed to export expenses: $e");
      return false;
    }
  }
}
