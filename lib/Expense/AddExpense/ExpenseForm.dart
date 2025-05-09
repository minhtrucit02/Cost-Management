import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final categoryController = TextEditingController();


  String selectedType = 'expense';
  String selectedSource = 'momo';
  DateTime selectedDate = DateTime.now();
  bool isLoader = false;

  late TabController _tabController;
  int _selectedCategoryIndex = -1;
  final List<String> categories = [
    'Ăn uống',
    'Chợ, siêu thị',
    'Mua sắm',
    'Hóa đơn',
    'Giải trí'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoader = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not logged in");

      final now = DateTime.now();
      final data = {
        "id": FirebaseFirestore.instance.collection('expense').doc().id,
        "userId": user.uid,
        "title": categoryController.text,
        "type": selectedType,
        "timestamp": Timestamp.fromDate(now),
        "monthYear": "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
        "amount": double.tryParse(amountController.text) ?? 0,
        "description": noteController.text,
      };

      await FirebaseFirestore.instance.collection('expense').add(data);
      setState(() => isLoader = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã thêm giao dịch thành công")),
      );
      Navigator.pop(context,true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ghi chép GD'),
        backgroundColor: Colors.blue.shade100,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.pink,
          labelColor: Colors.pink,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(icon: Icon(Icons.add_box), text: 'Nhập thủ công'),
            Tab(icon: Icon(Icons.image), text: 'Nhập bằng ảnh'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildManualEntryForm(),
          const Center(child: Text("Tính năng nhập bằng ảnh")),
        ],
      ),
    );
  }

  Widget _buildManualEntryForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              decoration: InputDecoration(
                labelText: 'Ngày giao dịch',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
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
                  text: "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
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
              onPressed: isLoader ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.pink,
              ),
              child: isLoader
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Thêm giao dịch', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
