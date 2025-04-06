import 'package:flutter/material.dart';

class ExpenseManagementScreen extends StatelessWidget {
  const ExpenseManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý chi tiêu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tình hình thu chi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircularGraph(),
            SizedBox(height: 16),
            Text(
              'Tháng này',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chi tiêu: 135.000đ'),
                Text('Giảm 55.000đ so với tháng trước'),
              ],
            ),
            SizedBox(height: 16),
            Text('Danh mục con'),
            Text('Giải trí: 135.000đ'),
          ],
        ),
      ),
    );
  }
}

class CircularGraph extends StatelessWidget {
  const CircularGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[100],
      ),
      child: Center(
        child: Text(
          '100% \nGiải trí',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}