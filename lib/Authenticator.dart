import 'dart:developer';

import 'package:serene/classes/User.dart';
import 'package:serene/dbHandling.dart';
import 'package:serene/sessionManagement.dart';

class Authenticator {
  static Future<bool> login(int pin) async {
    User? user = await DatabaseHelper().getUserById(0);
    if (await SessionManagement.sessionExists()) {
      SessionManagement.endAllSessions();
    }
    if (user == null || user.pin != pin) {
      log("Invalid User PIN");
      return false;
    } else {
      await SessionManagement.createNewSession(user);
      return true;
    }
  }

  static Future<void> register(int pin) async {
    User? user = await DatabaseHelper().getUserById(0);
    if (await SessionManagement.sessionExists()) {
      SessionManagement.endAllSessions();
    }
    if (user == null) {
      User newUser = User(id: 0, pin: pin);
      await DatabaseHelper().addUser(newUser);
      SessionManagement.createNewSession(newUser);
    } else {
      User newUser = User(
        id: user.id,
        pin: pin,
        currency: user.currency,
        name: user.name,
      );
      await DatabaseHelper().updateUser(newUser);
      SessionManagement.createNewSession(newUser);
    }
  }
}
