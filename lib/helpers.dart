import 'package:flutter/material.dart';
import 'package:serene/Enums/month.dart';

class Helpers {
  static DateTime getTodayDate() {
    return DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
  }

  static void showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static String prettyDateForExpenses(DateTime dt) {
    String prettyString = "";
    String prettyHour = (dt.hour.toString().length < 2)
        ? "0${dt.hour.toString()}"
        : dt.hour.toString();
    String prettyMinute = (dt.minute.toString().length < 2)
        ? "0${dt.minute.toString()}"
        : dt.minute.toString();
    prettyString =
        "${dt.month.month.prettyName} ${dt.day}, $prettyHour:$prettyMinute";
    return prettyString;
  }
}
