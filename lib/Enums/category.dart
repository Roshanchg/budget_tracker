import 'package:flutter/material.dart';
import 'package:serene/SomeConstants.dart';

enum CATEGORY { MISC, SAVINGS, SHOPPING, FOOD, TRANSPORTATION, RENT, GYM }

extension CategoryExtension on CATEGORY {
  String get displayName {
    switch (this) {
      case CATEGORY.MISC:
        return 'Miscellaneous';
      case CATEGORY.SAVINGS:
        return 'Savings';
      case CATEGORY.SHOPPING:
        return 'Shopping';
      case CATEGORY.FOOD:
        return 'Food & Grocerry';
      case CATEGORY.TRANSPORTATION:
        return 'Transportation';
      case CATEGORY.RENT:
        return 'Rent / Mortgage';
      case CATEGORY.GYM:
        return 'Gym & Fitness';
    }
  }

  IconData get icon {
    switch (this) {
      case CATEGORY.MISC:
        return Icons.category;
      case CATEGORY.FOOD:
        return Icons.restaurant;
      case CATEGORY.SAVINGS:
        return Icons.savings;
      case CATEGORY.SHOPPING:
        return Icons.shopping_bag;
      case CATEGORY.TRANSPORTATION:
        return Icons.directions_car;
      case CATEGORY.RENT:
        return Icons.house;
      case CATEGORY.GYM:
        return Icons.fitness_center;
    }
  }

  Color get fgcolor {
    switch (this) {
      case CATEGORY.MISC:
        return REDFOREGROUND;
      case CATEGORY.FOOD:
        return YELLOWFOREGROUND;
      case CATEGORY.SAVINGS:
        return GREENFOREGROUND;
      case CATEGORY.SHOPPING:
        return BLUEFOREGROUND;
      case CATEGORY.TRANSPORTATION:
        return ORANGEFOREGROUND;
      case CATEGORY.RENT:
        return PRIMARYCOLOR;
      case CATEGORY.GYM:
        return PINKFOREGROUND;
    }
  }

  Color get bgcolor {
    switch (this) {
      case CATEGORY.MISC:
        return REDBACKGROUND;
      case CATEGORY.FOOD:
        return YELLOWBACKGROUND;
      case CATEGORY.SAVINGS:
        return GREENBACKGROUND;
      case CATEGORY.SHOPPING:
        return BLUEBACKGROUND;
      case CATEGORY.TRANSPORTATION:
        return ORANGEBACKGROUND;
      case CATEGORY.RENT:
        return PURPLEBACKGROUND;
      case CATEGORY.GYM:
        return PINKBACKGROUND;
    }
  }

  String get asDbString => name;

  static CATEGORY fromString(String val) {
    return CATEGORY.values.firstWhere(
      (e) => e.name == val,
      orElse: () => throw ArgumentError('Invalid currency: $val'),
    );
  }
}
