import 'package:cost_management/services/Connected.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends StatefulWidget {
  const WeeklyChart({super.key});

  @override
  State<WeeklyChart> createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {
  late Future<List<int>> futureData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    futureData = totalExpenseWeek(DateTime(DateTime.now().year, DateTime.now().month));
  }

  void refreshData() {
    setState(() {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Data loading error"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No data"));
        }

        final weeklyTotals = snapshot.data!;
        final totalMonth = weeklyTotals.fold(0, (sum, item) => sum + item);
        final formatter = NumberFormat("#,##0", "vi_VN");

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Tổng chi tiêu tháng ${DateTime.now().month}: ${formatter.format(totalMonth)} đ",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: weeklyTotals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text("Tuần ${index + 1}"),
                    trailing: Text("${formatter.format(weeklyTotals[index])} đ"),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
