import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> printAllTransactions() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('⛔ User not logged in');
    return;
  }

  final userId = user.uid;

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      print('📭 No transactions found for user $userId');
      return;
    }

    print('📦 Transactions for user $userId:\n');

    for (var doc in snapshot.docs) {
      final data = doc.data();
      print('------------------------------');
      print('🧾 ID: ${data['id']}');
      print('📌 Title: ${data['title']}');
      print('💰 Amount: ${data['amount']}');
      print('📂 Category: ${data['category']}');
      print('📅 Date: ${data['timestamp']}');
      print('📈 Type: ${data['type']}');
      print('📆 Month-Year: ${data['monthYear']}');
      print('💳 Total Credit: ${data['totalCredit']}');
      print('💸 Total Debit: ${data['totalDebit']}');
      print('💼 Remaining: ${data['remainingAmount']}');
    }

  } catch (e) {
    print('❌ Error fetching transactions: $e');
  }
}
