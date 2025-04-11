import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Tuần / Tháng / Năm
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Biến động thu chi", style: TextStyle(color: Colors.black)),
          bottom: const TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(text: "Theo tuần"),
              Tab(text: "Theo tháng"),
              Tab(text: "Theo năm"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            InnerTab(title: "Tuần"),
            InnerTab(title: "Tháng"),
            InnerTab(title: "Năm"),
          ],
        ),
      ),
    );
  }
}

class InnerTab extends StatelessWidget {
  final String title;
  const InnerTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Thu nhập / Chi tiêu / Chênh lệch
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.black,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(text: "Thu nhập"),
              Tab(text: "Chi tiêu"),
              Tab(text: "Chênh lệch"),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                Center(child: Text("Thu nhập")),
                SpendingView(),
                Center(child: Text("Chênh lệch")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpendingView extends StatelessWidget {
  const SpendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text("Tổng chi tháng này", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          const Text("135.000đ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.arrow_downward, color: Colors.green, size: 16),
              Text("Giảm 55.000đ so với cùng kỳ tháng trước", style: TextStyle(color: Colors.green)),
              SizedBox(width: 4),
              Icon(Icons.info_outline, size: 16),
            ],
          ),
          const SizedBox(height: 16),

          // Fake bar chart
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final labels = ["T11", "T12", "T1", "T2", "T3", "Tháng này"];
                        return Text(labels[value.toInt()]);
                      },
                      interval: 1,
                    ),
                  ),
                ),
                barGroups: [
                  makeGroupData(0, 3.2),
                  makeGroupData(1, 0.4),
                  makeGroupData(2, 1.0),
                  makeGroupData(3, 0.6),
                  makeGroupData(4, 0.3),
                  makeGroupData(5, 0.1),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Chi tiêu cho", style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(onPressed: null, child: Text("↔ So sánh cùng kỳ")),
            ],
          ),

          // Tabs: Danh mục con / cha
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Row(
              children: [
                Expanded(child: Text("Danh mục con", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold))),
                Expanded(child: Text("Danh mục cha", textAlign: TextAlign.center)),
              ],
            ),
          ),

          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.movie_filter, color: Colors.pink),
            title: Text("Giải trí"),
            trailing: Text("135.000đ", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(toY: y, color: Colors.lightBlue, width: 18),
      ],
    );
  }
}
