import 'package:cost_management/Expense/ListExpense.dart';
import 'package:flutter/material.dart';

import '../Week/WeeklyChart.dart';

class InnerTab extends StatelessWidget {
  final String title;
  const InnerTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(text: "Chi tiêu"),
            ],
          ),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      WeeklyChart(),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Text("Tên chi tiêu", textAlign: TextAlign.center, style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold,))),
                      Expanded(child: Text("Số tiền", textAlign: TextAlign.center)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListExpense(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
