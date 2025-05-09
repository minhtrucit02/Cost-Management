import 'package:flutter/material.dart';

class FilterTransaction extends StatelessWidget {
  final Map<String, List<Map<String, dynamic>>> groupedExpenses;

  const FilterTransaction({super.key, required this.groupedExpenses});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: groupedExpenses.entries.map((entry) {
        final title = entry.key;
        final expenses = entry.value;
        final total = expenses.fold(0.0, (sum, item) => sum + (item['amount'] ?? 0.0));

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${expenses.length} giao dịch'),
            trailing: Text('${total.toStringAsFixed(0)}đ', style: const TextStyle(color: Colors.red)),
          ),
        );
      }).toList(),
    );
  }
}
