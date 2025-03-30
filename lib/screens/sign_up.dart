import 'package:cost_management/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:cost_management/utils/AppValidator.dart';


class SignUpView extends StatefulWidget{
  SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pssswordController = TextEditingController();

  var appValidator = AppValidator();
  var authService = AuthService();
  var isLoader = false;

  Future<void> _submitForm() async {
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoader = true;
      });
      var data = {
        'username': _userNameController.text,
        'email': _userNameController.text,
        'phone': _userNameController.text,
        'password': _userNameController.text
      };
      await authService.createUser(data, context);
      setState(() {
        isLoader =false;
      });
    }
  }


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
                  controller: _userNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Username",Icons.person),
                  validator: appValidator.validateUsername,
                ),
                SizedBox(
                  height: 16.0,
                ),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Email",Icons.email),
                  validator: appValidator.validateEmail,
                ),
                SizedBox(
                  height: 16.0,
                ),

                TextFormField(
                  controller: _phoneController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Phone",Icons.password),
                  validator: appValidator.validatePhoneNumber,
                ),
                SizedBox(
                  height: 16.0,

                ),

                TextFormField(
                  controller: _pssswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("PassWord",Icons.password),
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