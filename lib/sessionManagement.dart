import 'dart:developer';

import 'package:serene/classes/Income.dart';
import 'package:serene/classes/Session.dart';
import 'package:serene/classes/User.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/helpers.dart';

class SessionStorage {
  static SessionStorage? _instance;

  SessionStorage._internal();

  static SessionStorage get instance {
    _instance ??= SessionStorage._internal();
    return _instance!;
  }

  User? _user;
  Session? _session;
  Income? _income;

  User? get user => _user;
  Session? get session => _session;
  Income? get income => _income;

  set user(User? user) => _user = user;
  set session(Session? session) => _session = session;
  set income(Income? income) => _income = income;

  void clear() {
    _user = null;
    _session = null;
    _income = null;
  }

  bool get hasActiveSession => _user != null && _session != null;

  @override
  String toString() => "User: $_user, Session: $_session, Income: $_income";
}

class SessionManagement {
  static SessionStorage get _storage => SessionStorage.instance;

  static Future<void> createNewSession(User user) async {
    if (user.id == null) {
      return;
    }

    Session newSession = Session(
      userId: user.id!,
      date: Helpers.getTodayDate(),
    );

    await DatabaseHelper().addSession(newSession);

    _storage.user = user;
    _storage.session = newSession;
    _storage.income = await DatabaseHelper().getIncomeByUserId(user.id!);

    log("New session created for user: ${user.id}");
  }

  static bool isValidSession(Session session) {
    return session.date == Helpers.getTodayDate();
  }

  static void clearSessionStorage() {
    _storage.clear();
    log("Session storage cleared");
  }

  static Future<void> endAllSessions() async {
    await DatabaseHelper().deleteAllSessions();
    clearSessionStorage();
    log("All sessions ended");
  }

  static Future<bool> sessionExists() async {
    try {
      Session? session = await DatabaseHelper().getSessionByDate(
        Helpers.getTodayDate(),
      );

      if (session == null) {
        log("No session found for today");
        clearSessionStorage();
        return false;
      }

      log(
        "Session exists: userId=${session.userId}, date=${session.date}, id=${session.id}",
      );

      if (_storage.hasActiveSession) {
        return true;
      }

      User? user = await DatabaseHelper().getUserById(session.userId);
      if (user == null) {
        clearSessionStorage();
        return false;
      }

      if (user.id != null) {
        Income? income = await DatabaseHelper().getIncomeByUserId(user.id!);
        _storage.user = user;
        _storage.income = income;
        _storage.session = session;
        log("Session data loaded successfully");
        return true;
      } else {
        clearSessionStorage();
        return false;
      }
    } catch (e) {
      log("Error in sessionExists: $e");
      clearSessionStorage();
      return false;
    }
  }

  static bool isSessionValid() {
    if (!_storage.hasActiveSession) return false;
    return isValidSession(_storage.session!);
  }

  static Future<void> refreshSession() async {
    if (_storage.session != null) {
      await sessionExists();
    }
  }
}
