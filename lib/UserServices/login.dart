
import 'package:cost_management/UserServices/sign_up.dart';
import 'package:flutter/material.dart';

import '../home/home_screen_login.dart';
import '../services/auth_services.dart';
import '../utils/AppValidator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var appValidator = AppValidator();
  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoader = true;
      });
      var data = {
        'email': _emailController.text,
        'password': _passwordController.text,
      };
      await authService.login(data, context);
      setState(() {
        isLoader = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Background()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252634),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 50.0,
              ),
              SizedBox(
                width: 250,
                child: const Text(
                  "Login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildInputDecoration("Email", Icons.email),
                validator: appValidator.validateEmail,
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: _passwordController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _buildInputDecoration("Password", Icons.lock),
                validator: appValidator.validatePhoneNumber, // Use password validator
                obscureText: true, // Obscure password text
              ),
              const SizedBox(
                height: 40.0,
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                  ),
                  onPressed: () {
                    isLoader ? null : _submitForm(); // Prevent multiple submissions
                  },
                  child: isLoader
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('Login', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: const Text(
                  "Create new account",
                  style: TextStyle(color: Colors.yellow, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon) {
    return InputDecoration(
      fillColor: const Color(0xAA494A59),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x45949494))),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      filled: true,
      labelStyle: const TextStyle(color: Color(0xFF949494)),
      labelText: label,
      suffix: Icon(
        suffixIcon,
        color: const Color(0xFF949494),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    );
  }
}
