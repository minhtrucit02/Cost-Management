import 'package:flutter/material.dart';
import 'BudgetBody.dart';

class BudgetHeader extends StatelessWidget {
  const BudgetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Tuần / Tháng / Năm
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Biến động thu chi",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: const TabBarView(
          children: [
            InnerTab(title: "Tuần",),
            InnerTab(title: "Tháng"),
            InnerTab(title: "Năm"),
          ],
        ),
      ),

    );
  }
}

