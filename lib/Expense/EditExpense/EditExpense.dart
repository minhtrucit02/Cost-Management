import 'package:flutter/material.dart';

import 'EditExpenseForm.dart';

class EditExpense extends StatelessWidget {
  final Map<String, dynamic> expenseData;
  final String expenseId;

  const EditExpense({
    super.key,
    required this.expenseData,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EditExpenseForm(
        expenseData: expenseData,
        expenseId: expenseId,
      ),
    );
  }
}
