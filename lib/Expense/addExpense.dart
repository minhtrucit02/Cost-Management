import 'package:cost_management/Expense/ExpenseForm.dart';
import 'package:flutter/cupertino.dart';

class AddExpense extends StatefulWidget{
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  @override
  Widget build(BuildContext context) {
    return ExpenseForm();
  }
}