import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseService {
    /// Cập nhật tổng chi tiêu theo docId
  static Future<void> updateTotal(String docId) async {
    final docRef = FirebaseFirestore.instance.collection('expense').doc(docId);
    final docSnap = await docRef.get();

    if (!docSnap.exists) return;

    final data = docSnap.data() as Map<String, dynamic>;
    final expenses = List<Map<String, dynamic>>.from(data['expenses'] ?? []);
    final newTotal = expenses.fold(0, (sum, e) => sum + (e['amount'] as int));

    await docRef.update({'amount': newTotal});
  }

  /// Xoá một giao dịch theo timestamp
  static Future<void> deleteExpenseItem(String docId, String timestamp) async {
    final docRef = FirebaseFirestore.instance.collection('expense').doc(docId);
    final docSnap = await docRef.get();

    if (!docSnap.exists) return;

    final data = docSnap.data() as Map<String, dynamic>;
    final updatedList = List<Map<String, dynamic>>.from(data['expenses'] ?? [])
      ..removeWhere((e) => e['timestamp'] == timestamp);

    await docRef.update({'expenses': updatedList});
    await updateTotal(docId);
  }
}
