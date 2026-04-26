import 'package:serene/Enums/currency.dart';

class User {
  final int id;
  final String name;
  final CURRENCY currency;
  final bool biometric;
  final int pin;
  final bool darkMode;

  const User({
    required this.id,
    required this.name,
    required this.biometric,
    required this.currency,
    required this.pin,
    required this.darkMode,
  });

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      biometric: (map['biometric'] as int) == 1,
      currency: CurrencyExtension.fromString(map['currency'] as String),
      pin: map['pin'] as int,
      darkMode: (map['dark_mode'] as int) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'currency': currency.asDbString,
      'biometric': biometric ? 1 : 0,
      'pin': pin,
      'dark_mode': darkMode ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'User{id:$id,name:$name,pin:$pin}';
  }
}
