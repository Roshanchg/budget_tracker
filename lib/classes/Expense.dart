import 'package:serene/Enums/category.dart';

class Expense {
  final int id;
  final int userId;
  final int incomeId;
  final CATEGORY category;
  final String note;
  final int amount;
  final DateTime dateTime;

  const Expense({
    required this.id,
    required this.userId,
    required this.incomeId,
    required this.category,
    required this.amount,
    required this.note,
    required this.dateTime,
  });

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      incomeId: map['income_id'] as int,
      category: CategoryExtension.fromString(map['categoru'] as String),
      amount: map['amount'] as int,
      note: map['note'] as String,
      dateTime: DateTime.parse(map['datetime'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'income_id': incomeId,
      'category': category.asDbString,
      'note': note,
      'amount': amount,
      'datetime': dateTime,
    };
  }

  @override
  String toString() {
    return "Expense: id:$id, userId:$userId, incomeId:$incomeId, amount:$amount, dateTime:$dateTime";
  }
}
