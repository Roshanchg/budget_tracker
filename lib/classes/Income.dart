import 'package:serene/Enums/frequency.dart';

class Income {
  final int id;
  final int userId;
  final int amount;
  final FREQUENCY frequency;
  final DateTime dateAdded;

  const Income({
    required this.id,
    required this.userId,
    required this.amount,
    required this.frequency,
    required this.dateAdded,
  });

  factory Income.fromMap(Map<String, Object?> map) {
    return Income(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      amount: map['amount'] as int,
      frequency: FrequencyExtension.fromString(map['frequency'] as String),
      dateAdded: DateTime.parse(map['date_added'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'frequency': frequency,
      'date_added': dateAdded.toIso8601String(),
    };
  }

  @override
  String toString() {
    return "Income:id:$id, userId:$userId, amount:$amount";
  }
}
