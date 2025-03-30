import 'package:flutter/material.dart';
import 'package:cost_management/utils/AppValidator.dart';

class LoginScreen extends StatelessWidget{
  LoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _submitForm() async {
    if(_formKey.currentState!.validate()){
      ScaffoldMessenger.of(_formKey.currentContext!).showSnackBar(
        const SnackBar(content: Text('Form submit successfully')),
      );
    }
  }

  var appValidator = AppValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Username",Icons.person),
                  validator: appValidator.validateUsername,
                ),
                SizedBox(
                  height: 16.0,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Email",Icons.email),
                  validator: appValidator.validateEmail,
                ),
                SizedBox(
                  height: 16.0,
                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("PassWord",Icons.password),
                  validator: appValidator.validatePhoneNumber,
                ),
                SizedBox(
                  height: 16.0,

                ),

                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Register PassWord",Icons.password),
                  validator: appValidator.validatePhoneNumber,
                ),
                SizedBox(
                  height: 16.0,

                ),


                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () =>_submitForm, child: const Text('Submit')),
                ),

              ],
            ),
        ),
      )
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon){
    return InputDecoration(
        labelText: label,
        suffix: Icon(suffixIcon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
    );
  }

}