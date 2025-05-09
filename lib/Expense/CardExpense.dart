import 'package:flutter/material.dart';

class CardExpense extends StatelessWidget {
  final Map<String, dynamic> data;
  const CardExpense({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.money),
        title: Text(data['title'] ?? ''),
        subtitle: Text(data['note'] ?? ''),
        trailing: Text(
          "${data['amount'] ?? 0} đ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}