import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Tính tổng chi tiêu theo tuần dựa trên ngày được chọn
Future<List<int>> totalExpenseWeek(DateTime selectedMonth) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return [];

  final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
  final firstDayOfNextMonth = DateTime(
    selectedMonth.month == 12 ? selectedMonth.year + 1 : selectedMonth.year,
    selectedMonth.month == 12 ? 1 : selectedMonth.month + 1, 1,
  );

  // Tạo danh sách các mốc đầu tuần (bắt đầu từ Thứ Hai)
  List<DateTime> weekStarts = [];
  DateTime current = firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));
  while (current.isBefore(firstDayOfNextMonth)) {
    weekStarts.add(current);
    current = current.add(Duration(days: 7));
  }

  // Chuẩn bị mảng tổng chi tiêu cho từng tuần
  List<int> weeklyTotals = List.filled(weekStarts.length, 0);

  // Lấy dữ liệu chi tiêu từ Firestore trong tháng được chọn
  final snapshot = await FirebaseFirestore.instance
      .collection('expense')
      .where('userId', isEqualTo: user.uid)
      .where('type', isEqualTo: 'expense')
      .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
      .where('timestamp', isLessThan: Timestamp.fromDate(firstDayOfNextMonth))
      .get();

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final timestamp = data['timestamp'] as Timestamp?;
    final rawAmount = data['amount'];
    final int amount = (rawAmount is int)
        ? rawAmount
        : (rawAmount is double)
        ? rawAmount.toInt()
        : 0;

    if (timestamp == null) continue;
    final date = timestamp.toDate();

    for (int i = 0; i < weekStarts.length; i++) {
      final weekStart = weekStarts[i];
      final weekEnd = weekStart.add(Duration(days: 6));

      if (!date.isBefore(weekStart) && !date.isAfter(weekEnd)) {
        weeklyTotals[i] += amount;
        break;
      }
    }
  }

  return weeklyTotals;
}
