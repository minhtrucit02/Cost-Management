import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditExpenseForm extends StatefulWidget {
  final Map<String, dynamic> expenseData;
  final String expenseId;

  const EditExpenseForm({
    super.key,
    required this.expenseData,
    required this.expenseId,
  });

  @override
  State<EditExpenseForm> createState() => _EditExpenseFormState();
}

class _EditExpenseFormState extends State<EditExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final categoryController = TextEditingController();

  String selectedType = 'expense';
  String selectedSource = 'momo';
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  final List<String> categories = [
    'Ăn uống',
    'Chợ, siêu thị',
    'Mua sắm',
    'Hóa đơn',
    'Giải trí'
  ];

  int _selectedCategoryIndex = -1;

  @override
  void initState() {
    super.initState();
    final data = widget.expenseData;

    amountController.text = data['amount'].toString();
    noteController.text = data['description'] ?? '';
    categoryController.text = data['title'] ?? '';
    selectedType = data['type'] ?? 'expense';
    selectedDate = (data['timestamp'] as Timestamp).toDate();

    // Gán index cho chip
    _selectedCategoryIndex = categories.indexOf(categoryController.text);
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> _updateExpense() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      final updatedData = {
        "title": categoryController.text,
        "type": selectedType,
        "timestamp": Timestamp.fromDate(selectedDate),
        "monthYear": "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
        "amount": double.tryParse(amountController.text) ?? 0,
        "description": noteController.text,
      };

      await FirebaseFirestore.instance
          .collection('expense')
          .doc(widget.expenseId)
          .update(updatedData);

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã cập nhật giao dịch")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa giao dịch'),
        backgroundColor: Colors.blue.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ToggleButtons(
                isSelected: [selectedType == 'expense', selectedType == 'income'],
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.pink,
                color: Colors.black,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Chi tiêu'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Thu nhập'),
                  ),
                ],
                onPressed: (index) {
                  setState(() => selectedType = index == 0 ? 'expense' : 'income');
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Số tiền',
                  suffixText: 'đ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Vui lòng nhập số tiền' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Danh mục',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: List.generate(categories.length, (index) {
                  return ChoiceChip(
                    label: Text(categories[index]),
                    selected: _selectedCategoryIndex == index,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedCategoryIndex = selected ? index : -1;
                        categoryController.text = selected ? categories[index] : '';
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Ngày giao dịch',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                  }
                },
                controller: TextEditingController(
                  text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : _updateExpense,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.orange,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Cập nhật giao dịch', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
