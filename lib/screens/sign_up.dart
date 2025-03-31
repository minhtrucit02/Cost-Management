import 'package:cost_management/home/Dashboard.dart';
import 'package:cost_management/screens/login_screen.dart';
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
        'email': _emailController.text,
        'phone': _phoneController.text,
        'password': _pssswordController.text
      };
      await authService.createUser(data, context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
      setState(() {
        isLoader =false;
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

                SizedBox(
                  height: 50.0,
                ),

                SizedBox(
                  width: 250,
                  child: Text(
                    "Create new account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                SizedBox(
                  height: 16.0,
                ),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: _userNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Username",Icons.person),
                  validator: appValidator.validateUsername,
                ),
                SizedBox(
                  height: 16.0,
                ),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  controller: _emailController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Email",Icons.email),
                  validator: appValidator.validateEmail,
                ),
                SizedBox(
                  height: 16.0,
                ),

                TextFormField(
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white),
                  controller: _phoneController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("Phone",Icons.password),
                  validator: appValidator.validatePhoneNumber,
                ),
                SizedBox(
                  height: 16.0,

                ),

                TextFormField(

                  style: TextStyle(color: Colors.white),
                  controller: _pssswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildInputDecoration("PassWord",Icons.password),
                  validator: appValidator.validatePhoneNumber,
                ),
                SizedBox(
                  height: 40.0,
                ),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                      ),
                      onPressed: (){
                        isLoader ? print("Loading") :_submitForm();
                      },
                      child:
                          isLoader ?
                          Center(child: CircularProgressIndicator()):
                          Text('Create',style: TextStyle(fontSize: 20))
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),

                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                      );
                    },
                    child: Text("Login",style: TextStyle(color: Colors.yellow, fontSize: 20))),

              ],
            ),
          ),
        )
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData suffixIcon){
    return InputDecoration(
        fillColor: Color(0xAA494A59),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x45949494))),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
        filled: true,
        labelStyle: TextStyle(color: Color(0xFF949494)),
        labelText: label,
        suffix: Icon(suffixIcon,
          color: Color(0xFF949494),),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))
    );
  }

}