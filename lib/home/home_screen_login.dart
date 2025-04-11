import 'package:cost_management/Budget/budget.dart';
import 'package:cost_management/Expense/addExpense.dart';
import 'package:cost_management/account/account_user.dart';
import 'package:flutter/material.dart';

import '../Action_background/ActionIcon.dart';
import '../Action_background/ExpenseSumary.dart';

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  State<Background> createState() => BackgroundState();
}


class _ActionItem {
  final IconData icon;
  final String label;
  final Widget screen;

  const _ActionItem({required this.icon, required this.label, required this.screen});
}

class BackgroundState extends State<Background> {
  int _currentIndex = 0;

  final List<_ActionItem> _actionItems = [
    _ActionItem(icon: Icons.label, label: "Phân loại\nGiao dịch", screen: Budget()),
    _ActionItem(icon: Icons.edit_note, label: "Ghi chép\nGiao dịch", screen: AddExpense()),
    _ActionItem(icon: Icons.show_chart, label: "Biến động\nThu chi", screen: Budget()),
    _ActionItem(icon: Icons.widgets_outlined, label: "Tiện ích\nkhác", screen: Budget()),
  ];

  void _handleNavigation(int index){
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => Background()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => AddExpense()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => Budget()));
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (_) => Background()));
        break;
      default:

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text('Quản lý chi tiêu'),
        actions: const [AccountUser()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 20),
            _buildExpenseOverview(),
            const SizedBox(height: 40),
            _buildSummaryChart(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Tổng quan"),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Sổ giao dịch"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: "Ghi chép GD"),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Ngân sách"),
          BottomNavigationBarItem(icon: Icon(Icons.extension), label: "Tiện ích"),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _actionItems.map((item) {
          return ActionIcon(
            icon: item.icon,
            label: item.label,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item.screen),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text("Tình hình thu chi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.remove_red_eye_outlined),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                ExpenseSummary(title: "Chi tiêu", amount: "135.000đ"),
                ExpenseSummary(title: "Thu nhập", amount: "65đ"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChart() {
    return Container(
      width: 150,
      height: 150,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: SweepGradient(
          colors: [Colors.pink, Colors.pink, Colors.pink, Colors.white],
          stops: [0.0, 1.0, 1.0, 1.0],
        ),
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}



