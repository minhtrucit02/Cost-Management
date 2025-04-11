import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cost_management/utils/AppValidator.dart';
import 'package:cost_management/widgets/category_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  var type = 'cr';
  var category = "Others";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var isLoader = false;
  var appValidator = AppValidator();
  var amountEditController = TextEditingController();
  var titleEditController = TextEditingController();
  var uid = Uuid();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      Timestamp timestamp = Timestamp.now();
      int amount = int.parse(amountEditController.text);
      DateTime date = DateTime.now();
      String id = uid.v4();
      String monthYear = DateFormat(' d MM yyy hh:mma ').format(date);
      String userId = user.uid;

      // Retrieve user document
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      await FirebaseFirestore.instance.collection('users').doc(userId).update({

      });


      var data = {
        "id": id,
        "userId": userId,
        "title": titleEditController.text,
        "type": type,
        "timestamp": timestamp,
        "monthYear": monthYear,
        "description":"",
      };

      await FirebaseFirestore.instance.collection('transactions').doc(id).set(data);

      Navigator.pop(context);

      setState(() {
        isLoader = false;
      });
    }
  }  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleEditController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: appValidator.isEmptyCheck,
                decoration: InputDecoration(labelText: 'Title')),
            TextFormField(
              controller: amountEditController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: appValidator.isEmptyCheck,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            CategoryDropDown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            DropdownButtonFormField(
              value: 'Credit',
              items: [
                DropdownMenuItem(value: 'Credit', child: Text('Credit')),
                DropdownMenuItem(value: 'Debit', child: Text('Debit')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    type = value;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: () {
              if(isLoader == false) {
                _submitForm();
              }
            },
                child:
                    isLoader? Center(child: CircularProgressIndicator()):Text('Add Transaction')),
          ],
        ),
      ),
    );
  }
}
