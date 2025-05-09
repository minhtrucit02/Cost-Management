import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _selectedImage;
  final picker = ImagePicker();
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      String userId = userCredential.user!.uid;

      String? imageUrl;
      if (_selectedImage != null) {
        final ref = FirebaseStorage.instance.ref().child('avatars/$userId.jpg');
        await ref.putFile(_selectedImage!);
        imageUrl = await ref.getDownloadURL();
      }
      var data = {
        'userId': userId,
        'username': _userNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text.trim(),
        'updateAt': FieldValue.serverTimestamp(),
        'image': imageUrl ?? '',
      };

      await FirebaseFirestore.instance.collection("users").doc(userId).set(
          data);

      _userNameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
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
      setState(() {
        isLoading = false;
      });
    }
  }

    Future<void> _pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFF252634),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50.0),
                const Text(
                  "Create new account",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32.0),

                _buildTextField("Username", Icons.person, _userNameController),
                _buildTextField("Email", Icons.email, _emailController),
                _buildTextField("Phone", Icons.phone, _phoneController),
                _buildTextField("Password", Icons.lock, _passwordController,
                    isPassword: true),

                const SizedBox(height: 30.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow),
                    onPressed:  isLoading ? null : _submitForm,
                    child: const Text('Create', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login())
                    );
                  },
                  child: const Text("Login",
                      style: TextStyle(color: Colors.yellow, fontSize: 20)),
                ),
              ],
            ),
          ),
        ),
      );
    }
  Widget _buildTextField(
      String label,
      IconData icon,
      TextEditingController controller, {
        bool isPassword = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          if (label == "Email" && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          if (label == "Password" && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: const Color(0xAA494A59),
          filled: true,
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF949494)),
          suffixIcon: Icon(icon, color: const Color(0xFF949494)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
  }