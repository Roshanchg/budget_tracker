import 'dart:developer';

import 'package:serene/classes/Income.dart';
import 'package:serene/classes/Session.dart';
import 'package:serene/classes/User.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/helpers.dart';

class SessionStorage {
  User? _user;
  Session? _session;
  Income? _income;

  static final SessionStorage _instance = SessionStorage._internal();

  factory SessionStorage() => _instance;
  SessionStorage._internal();

  set user(User user) {
    _user = user;
  }

  set session(Session session) {
    _session = session;
  }

  set income(Income? income) {
    _income = income;
  }

  User? get user => _user;
  Session? get session => _session;
  Income? get income => _income;
}

class SessionManagement {
  static Future<void> createNewSession(User user) async {
    Session newSession = Session(
      userId: user.id!,
      date: Helpers.getTodayDate(),
    );
    await DatabaseHelper().addSession(newSession);
    SessionStorage()._session = newSession;
    SessionStorage()._user = user;
    SessionStorage()._income = await DatabaseHelper().getIncomeByUserId(
      user.id!,
    );
  }

  static bool isValidSession(Session session) {
    return (session.date == Helpers.getTodayDate());
  }

  static void clearSessionStorage() {
    SessionStorage()._income = null;
    SessionStorage()._user = null;
    SessionStorage()._session = null;
  }

  static Future<void> endAllSessions() async {
    await DatabaseHelper().deleteAllSessions();
    clearSessionStorage();
  }

  static Future<bool> sessionExists() async {
    Session? session = await DatabaseHelper().getSessionByDate(
      Helpers.getTodayDate(),
    );
    if (session == null) {
      clearSessionStorage();
      return false;
    } else {
      log("session exists: ${session.userId}, ${session.date}, ${session.id}");
      if (SessionStorage()._user != null && SessionStorage()._session != null) {
        return true;
      } else {
        User? user = await DatabaseHelper().getUserById(session.userId);
        clearSessionStorage();
        SessionStorage().user = user!;
        SessionStorage().income = await DatabaseHelper().getIncomeByUserId(
          user.id!,
        );
        SessionStorage().session = session;
        return true;
      }
    }
  }
}
