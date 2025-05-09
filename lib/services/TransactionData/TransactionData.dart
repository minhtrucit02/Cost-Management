import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, List<Map<String, dynamic>>>> fetchAndGroupExpenses() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return {};

  final now = DateTime.now();
  final selectedMonthYear = '${now.month}-${now.year}';

  final snapshot = await FirebaseFirestore.instance
      .collection('expense')
      .where('userId', isEqualTo: user.uid)
      .where('monthYear', isEqualTo: selectedMonthYear)
      .get();

  final allExpenses = snapshot.docs.map((doc) => doc.data()).toList();

  final grouped = <String, List<Map<String, dynamic>>>{};
  for (var expense in allExpenses) {
    final title = expense['title'] ?? 'Khác';
    grouped.putIfAbsent(title, () => []);
    grouped[title]!.add(expense);
  }

  return grouped;
}
