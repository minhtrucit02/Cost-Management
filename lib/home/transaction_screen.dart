import 'package:cost_management/widgets/time_line_month.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expansive')),
      body: Column(
        children: [
          TimeLineMonth(),
        ],
      )
    );
  }
}
