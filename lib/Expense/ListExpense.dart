import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cost_management/Expense/EditExpense/EditExpense.dart';
import 'package:cost_management/Expense/WeekCardExpense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ListExpense extends StatefulWidget {
  const ListExpense({super.key});

  @override
  State<ListExpense> createState() => _ListExpenseState();
}

class _ListExpenseState extends State<ListExpense> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Center(child: Text('User not logged in.'));
    }

    final now = DateTime.now();
    final firstDayOfMonth     = DateTime(now.year, now.month, 1);
    final firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);

    final userId = currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('expense')
          .where('userId',      isEqualTo: userId)
          .where('timestamp',   isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
          .where('timestamp',   isLessThan:            Timestamp.fromDate(firstDayOfNextMonth))
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Đã xảy ra lỗi khi tải dữ liệu"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return const Center(child: Text("Không có giao dịch nào trong tháng này"));
        }

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final doc      = docs[i];
            final cardData = doc.data() as Map<String, dynamic>;

            return WeekCardExpense(
              data: cardData,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditExpense(
                      expenseData: cardData,
                      expenseId:   doc.id,
                    ),
                  ),
                );
              },
              onDelete: () async {
                await FirebaseFirestore.instance
                    .collection('expense')
                    .doc(doc.id)
                    .delete();
                if (mounted) setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa thành công'))
                );
              },
            );
          },
        );
      },
    );
  }
}
