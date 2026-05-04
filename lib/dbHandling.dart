import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:serene/classes/Budgets.dart';
import 'package:serene/classes/Expense.dart';
import 'package:serene/classes/Session.dart';
import 'package:serene/classes/User.dart';
import 'package:serene/classes/Income.dart';
import 'package:sqflite/sqflite.dart';

const String databaseName = "financeDB.db";

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _init_db();
    return _database!;
  }

  Future<Database> _init_db() async {
    String path = join(await getDatabasesPath(), databaseName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        currency TEXT NOT NULL,
        biometric INTEGER NOT NULL DEFAULT 0,
        dark_mode INTEGER NOT NULL DEFAULT 0,
        pin INTEGER NOT NULL
      )
    ''');

    // Session table
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Income table
    await db.execute('''
      CREATE TABLE incomes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        amount INTEGER NOT NULL,
        frequency TEXT NOT NULL,
        date_added TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');

    // Budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        income_id INTEGER NOT NULL,
        category TEXT NOT NULL,
        name TEXT NOT NULL,
        amount INTEGER NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (income_id) REFERENCES income (id) ON DELETE CASCADE
      )
    ''');

    // Expenses table
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        income_id INTEGER NOT NULL,
        amount INTEGER NOT NULL,
        category TEXT NOT NULL,
        datetime TEXT NOT NULL,
        note TEXT,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
        FOREIGN KEY (income_id) REFERENCES income (id) ON DELETE CASCADE
      )
    ''');
  }

  // USERS

  Future<int> addUser(User user) async {
    try {
      final db = await database;
      return await db.insert('users', user.toMap());
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('users');
      return maps.map((map) => User.fromMap(map)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<User?> getUserById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return User.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int> updateUser(User user) async {
    try {
      final db = await database;
      return await db.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteuser(int id) async {
    try {
      final db = await database;
      return await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteAllUsers() async {
    try {
      final db = await database;
      return await db.delete('users');
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }
  // USERS END;

  // Sessions

  Future<int> addSession(Session session) async {
    try {
      final db = await database;
      return await db.insert('sessions', session.toMap());
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<List<Session>?> getAllSessions() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('sessions');
      return maps.map((map) => Session.fromMap(map)).toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Session?> getSessionById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'sessions',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Session.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Session?> getSessionByDate(DateTime date) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'sessions',
        where: 'date = ?',
        whereArgs: [date.toIso8601String()],
      );
      if (maps.isNotEmpty) {
        return Session.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Session?> getSessionByUserId(int userId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'sessions',
        where: 'user_id = ? ',
        whereArgs: [userId],
      );
      if (maps.isNotEmpty && maps.length != 1) {
        return Session.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int> updateSession(Session session) async {
    try {
      final db = await database;
      return await db.update(
        'sessions',
        session.toMap(),
        where: 'id = ?',
        whereArgs: [session.id],
      );
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteSession(int id) async {
    try {
      final db = await database;
      return await db.delete('sessions', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteAllSessions() async {
    try {
      final db = await database;
      return await db.delete('sessions');
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  // SESSIONS END;

  // INCOMES

  Future<int> addIncome(Income income) async {
    try {
      final db = await database;
      return await db.insert('incomes', income.toMap());
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<List<Income>> getAllIncomes() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('incomes');
      return maps.map((map) => Income.fromMap(map)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<Income?> getIncomeById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'incomes',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Income.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Income?> getIncomeByUserId(int userId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'incomes',
        where: 'user_id = ? ',
        whereArgs: [userId],
        orderBy: 'date_added DESC',
      );
      if (maps.isNotEmpty) {
        return Income.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int> updateIncome(Income income) async {
    try {
      final db = await database;
      return await db.update(
        'incomes',
        income.toMap(),
        where: 'id = ?',
        whereArgs: [income.id],
      );
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteIncome(int id) async {
    try {
      final db = await database;
      return await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteAllIncomes() async {
    try {
      final db = await database;
      return await db.delete('incomes');
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  // INCOMES END;

  // BUDGETS

  Future<int> addBudget(Budgets budget) async {
    try {
      final db = await database;
      return await db.insert('budgets', budget.toMap());
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<List<Budgets>> getAllBudgets() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('budgets');
      return maps.map((map) => Budgets.fromMap(map)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<Budgets?> getBudgetById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'budgets',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Budgets.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<Budgets>> getBudgetsByIncomeId(int incomeId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'budgets',
        where: 'income_id = ? ',
        whereArgs: [incomeId],
        orderBy: 'amount DESC',
      );
      if (maps.isNotEmpty) {
        return maps.map((map) => Budgets.fromMap(map)).toList();
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<int> updateBudget(Budgets budget) async {
    try {
      final db = await database;
      return await db.update(
        'budgets',
        budget.toMap(),
        where: 'id = ?',
        whereArgs: [budget.id],
      );
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteBudget(int id) async {
    try {
      final db = await database;
      return await db.delete('budgets', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteAllBudgets() async {
    try {
      final db = await database;
      return await db.delete('budgets');
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  // BUDGETS END;

  // EXPENSES

  Future<int> addExpense(Expense expense) async {
    try {
      final db = await database;
      return await db.insert('expenses', expense.toMap());
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<List<Expense>> getAllExpenses() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('expenses');
      return maps.map((map) => Expense.fromMap(map)).toList();
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<Expense?> getExpenseById(int id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'expenses',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isNotEmpty) {
        return Expense.fromMap(maps.first);
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<Expense>> getExpensesByIncomeId(int incomeId) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'expenses',
        where: 'income_id = ? ',
        whereArgs: [incomeId],
        orderBy: 'datetime ASC',
      );
      if (maps.isNotEmpty) {
        return maps.map((map) => Expense.fromMap(map)).toList();
      }
      return [];
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  Future<int> updateExpense(Expense expense) async {
    try {
      final db = await database;
      return await db.update(
        'expenses',
        expense.toMap(),
        where: 'id = ?',
        whereArgs: [expense.id],
      );
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteExpense(int id) async {
    try {
      final db = await database;
      return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  Future<int> deleteAllExpenses() async {
    try {
      final db = await database;
      return await db.delete('expenses');
    } catch (e) {
      log(e.toString());
      return -1;
    }
  }

  // EXPENSES END;

  Future<void> removeDB() async {
    try {
      final db = await database;
      db.close();
      await deleteDatabase(db.path);
    } catch (e) {
      log("IDK MAN");
    }
  }
}
