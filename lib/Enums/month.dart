enum MONTH {
  JANUARY,
  FEBRUARY,
  MARCH,
  APRIL,
  MAY,
  JUNE,
  JULY,
  AUGUST,
  SEPTEMBER,
  OCTOBER,
  NOVEMBER,
  DECEMBER,
}

extension MonthExtension on MONTH {
  String get prettyName {
    return name;
  }

  String get chartName {
    return name[0] + name.substring(1, 3);
  }

  int get number {
    switch (this) {
      case MONTH.JANUARY:
        return 1;
      case MONTH.FEBRUARY:
        return 2;
      case MONTH.MARCH:
        return 3;
      case MONTH.APRIL:
        return 4;
      case MONTH.MAY:
        return 5;
      case MONTH.JUNE:
        return 6;
      case MONTH.JULY:
        return 7;
      case MONTH.AUGUST:
        return 8;
      case MONTH.SEPTEMBER:
        return 9;
      case MONTH.OCTOBER:
        return 10;
      case MONTH.NOVEMBER:
        return 11;
      case MONTH.DECEMBER:
        return 12;
    }
  }

  MONTH monthFromNumber(int number) {
    switch (number) {
      case 1:
        return MONTH.JANUARY;
      case 2:
        return MONTH.FEBRUARY;
      case 3:
        return MONTH.MARCH;
      case 4:
        return MONTH.APRIL;
      case 5:
        return MONTH.MAY;
      case 6:
        return MONTH.JUNE;
      case 7:
        return MONTH.JULY;
      case 8:
        return MONTH.AUGUST;
      case 9:
        return MONTH.SEPTEMBER;
      case 10:
        return MONTH.OCTOBER;
      case 11:
        return MONTH.NOVEMBER;
      case 12:
        return MONTH.DECEMBER;
      default:
        return MONTH.JANUARY;
    }
  }
}

extension NumberToMonth on int {
  MONTH get month {
    switch (this) {
      case 1:
        return MONTH.JANUARY;
      case 2:
        return MONTH.FEBRUARY;
      case 3:
        return MONTH.MARCH;
      case 4:
        return MONTH.APRIL;
      case 5:
        return MONTH.MAY;
      case 6:
        return MONTH.JUNE;
      case 7:
        return MONTH.JULY;
      case 8:
        return MONTH.AUGUST;
      case 9:
        return MONTH.SEPTEMBER;
      case 10:
        return MONTH.OCTOBER;
      case 11:
        return MONTH.NOVEMBER;
      case 12:
        return MONTH.DECEMBER;
      default:
        return MONTH.JANUARY;
    }
  }
}
