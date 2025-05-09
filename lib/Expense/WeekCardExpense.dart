import 'package:flutter/material.dart';

class WeekCardExpense extends StatelessWidget {
  const WeekCardExpense({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  final Map<String, dynamic> data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _formatDate(DateTime date) =>
      "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

  @override
  Widget build(BuildContext context) {
    final timestamp = data['timestamp'];
    final DateTime date = timestamp is DateTime
        ? timestamp
        : timestamp is String
        ? DateTime.parse(timestamp)
        : timestamp.toDate();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.money),
              title: Text(data['title'] ?? 'Không rõ'),
              subtitle: Text("Ngày: ${_formatDate(date)}"),
              trailing: Text(
                "${data['amount'] ?? 0} đ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Xác nhận xóa"),
                        content: const Text("Bạn có chắc chắn muốn xóa khoản chi này không?"),
                        actions: [
                          TextButton(
                            child: const Text("Hủy"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("Xóa", style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                              onDelete();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
