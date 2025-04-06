import 'package:flutter/material.dart';
import '../services/db_test.dart'; // nơi chứa hàm printAllTransactions()

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            printAllTransactions(); // gọi hàm in dữ liệu
          },
          child: const Text("Print All Transactions"),
        ),
      ),
    );
  }
}
