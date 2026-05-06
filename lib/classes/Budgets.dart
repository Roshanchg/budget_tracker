import 'package:serene/Enums/category.dart';

class Budgets {
  final int? id;
  final int userId;
  final int incomeId;
  final CATEGORY category;
  final String name;
  final double amount;

  const Budgets({
    this.id,
    required this.userId,
    required this.incomeId,
    required this.category,
    required this.amount,
    required this.name,
  });

  factory Budgets.fromMap(Map<String, Object?> map) {
    return Budgets(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      incomeId: map['income_id'] as int,
      category: CategoryExtension.fromString(map['category'] as String),
      amount: map['amount'] as double,
      name: map['name'] as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'income_id': incomeId,
      'category': category.asDbString,
      'name': name,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return "Budget: id:$id, userId:$userId, incomeId:$incomeId, limit:$amount, cat:$category";
  }
}
