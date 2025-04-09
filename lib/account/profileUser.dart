import 'package:flutter/material.dart';

class ProfileUser extends StatelessWidget{
  const ProfileUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text('Thông tin cá nhân'),
        centerTitle: true,
      ),
    );
  }
}
