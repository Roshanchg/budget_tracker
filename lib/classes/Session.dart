class Session {
  final int id;
  final int userId;
  final DateTime date;
  const Session({required this.id, required this.userId, required this.date});

  factory Session.fromMap(Map<String, Object?> map) {
    return Session(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      date: DateTime.parse(map['date'].toString()),
    );
  }

  Map<String, Object?> toMap() {
    return {'id': id, 'user_id': userId, 'date': date};
  }

  @override
  String toString() {
    return "Session: id:$id, userId:$userId, date:$date";
  }
}
