import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FilterTransactionScreen extends StatefulWidget {
  const FilterTransactionScreen({Key? key}) : super(key: key);

  @override
  _FilterTransactionScreenState createState() => _FilterTransactionScreenState();
}

class _FilterTransactionScreenState extends State<FilterTransactionScreen> {
  Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> groupedData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndGroupExpenses();
  }

  Future<void> fetchAndGroupExpenses() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('expense')
        .where('userId', isEqualTo: user.uid)
        .get();

    final expenses = snapshot.docs.map((doc) => doc.data()).toList();

    final Map<String, Map<String, Map<String, List<Map<String, dynamic>>>>> result = {};

    for (var expense in expenses) {
      final timestamp = (expense['timestamp'] as Timestamp?)?.toDate();
      if (timestamp == null) continue;

      final monthYear = DateFormat('MM-yyyy').format(timestamp);
      final day = DateFormat('dd-MM-yyyy').format(timestamp);
      final title = expense['title'] ?? 'Không rõ';

      result.putIfAbsent(monthYear, () => {});
      result[monthYear]!.putIfAbsent(title, () => {});
      result[monthYear]![title]!.putIfAbsent(day, () => []);
      result[monthYear]![title]![day]!.add(expense);
    }

    // Sắp xếp tháng giảm dần
    final sortedKeys = result.keys.toList()
      ..sort((a, b) {
        final aDate = DateFormat('MM-yyyy').parse(a);
        final bDate = DateFormat('MM-yyyy').parse(b);
        return bDate.compareTo(aDate); // Descending
      });

    final sortedData = {for (var k in sortedKeys) k: result[k]!};

    setState(() {
      groupedData = sortedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Giao dịch theo tháng')),
      body: ListView(
        children: groupedData.entries.map((monthEntry) {
          final month = monthEntry.key;
          final titles = monthEntry.value;

          return ExpansionTile(
            title: Text('Tháng: $month'),
            children: titles.entries.map((titleEntry) {
              final title = titleEntry.key;
              final days = titleEntry.value;

              final total = days.values
                  .expand((eList) => eList)
                  .fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));

              return ExpansionTile(
                title: Text('$title - Tổng: ${total.toStringAsFixed(0)} đ'),
                children: days.entries.map((dayEntry) {
                  final day = dayEntry.key;
                  final expenses = dayEntry.value;
                  final dailyTotal = expenses.fold(0.0, (sum, e) => sum + (e['amount'] ?? 0.0));

                  return ExpansionTile(
                    title: Text('Ngày $day - ${dailyTotal.toStringAsFixed(0)} đ'),
                    children: expenses.map((e) {
                      return ListTile(
                        title: Text(e['description'] ?? '(Không mô tả)'),
                        subtitle: Text('${e['amount']} đ'),
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
