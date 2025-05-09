import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final DateTime date;
  final int amount;

  Expense({required this.date, required this.amount});
}
Future<List<Expense>> fetchExpenses() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('expenses')
      .get();

  return snapshot.docs.map((doc) {
    final data = doc.data();
    return Expense(
      date: (data['date'] as Timestamp).toDate(),
      amount: data['amount'],
    );
  }).toList();
}

// Future<List<int>> totalExpenseWeek(DateTime month) async {
//   List<Expense> allExpenses = await fetchExpenses();
//
//   final filtered = allExpenses.where((e) =>
//   e.date.year == month.year && e.date.month == month.month);
//
//   List<int> weeklyTotals = List.filled(5, 0);
//
//   for (var expense in filtered) {
//     final day = expense.date.day;
//     int weekIndex = (day - 1) ~/ 7;
//     if (weekIndex >= 5) weekIndex = 4;
//
//     weeklyTotals[weekIndex] += expense.amount;
//   }
//
//   return weeklyTotals;
// }
