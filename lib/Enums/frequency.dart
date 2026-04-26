enum FREQUENCY { monthly, yearly }

extension FrequencyExtension on FREQUENCY {
  String get asDbString => name;

  static FREQUENCY fromString(String val) {
    return FREQUENCY.values.firstWhere(
      (e) => e.name == val,
      orElse: () => throw ArgumentError('Invalid currency: $val'),
    );
  }
}
