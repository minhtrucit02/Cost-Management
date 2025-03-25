import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{
  LoginScreen({super.key});

  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              ),
            ),
            SizedBox(
              height: 16.0,
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              ),
            ),
            SizedBox(
              height: 16.0,
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              ),
            ),
            SizedBox(
              height: 16.0,
            ),

            Container(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(onPressed:  () {}, child: Text('Submit')),
            ),

          ],
        )),
      )
    );
  }
}