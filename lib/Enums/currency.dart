enum CURRENCY { USD, NRP }

extension CurrencyExtension on CURRENCY {
  String get asDbString => name;
  static CURRENCY fromString(String dbString) {
    return CURRENCY.values.firstWhere(
      (e) => e.name == dbString,
      orElse: () => throw ArgumentError('Invalid currency: $dbString'),
    );
  }
}
