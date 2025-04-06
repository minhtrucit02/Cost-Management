import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cost_management/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/dashboard.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String userId = userCredential.user!.uid;

        var data = {
          'userId': userId,
          'username': _userNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'remainingAmount': 0,
          'totalCredit': 0,
          'totalDebit': 0,
          'updateAt': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance.collection("users").doc(userId).set(data);

        // Clear fields
        _userNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginView()),
        );
      } catch (e) {
        // Specific error handling
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("The email is already registered.")),
            );
          } else if (e.code == 'weak-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("The password is too weak.")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${e.message}")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred.")),
          );
        }
      }

      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252634),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50.0),
              Text(
                "Create new account",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              _buildTextField("Username", Icons.person, _userNameController),
              _buildTextField("Email", Icons.email, _emailController),
              _buildTextField("Phone", Icons.phone, _phoneController),
              _buildTextField("Password", Icons.lock, _passwordController, isPassword: true),
              SizedBox(height: 40.0),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  onPressed: isLoading ? null : _submitForm,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text('Create', style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(height: 30.0),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView())
                  );
                },
                child: Text("Login", style: TextStyle(color: Colors.yellow, fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: Color(0xAA494A59),
          filled: true,
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF949494)),
          suffixIcon: Icon(icon, color: Color(0xFF949494)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}