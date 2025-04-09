import 'package:cost_management/UserServices/login.dart';
import 'package:cost_management/UserServices/sign_up.dart';
import 'package:cost_management/account/profileUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/home_screen_login.dart';

class AccountUser extends StatelessWidget {
  const AccountUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTapDown: (TapDownDetails detail) {
          _showInforUser(context, detail.globalPosition);
        },
        child: CircleAvatar(
          // backgroundImage: AssetImage(),
          radius: 18,
          // backgroundImage: AssetImage(),
          child: Icon(Icons.account_circle, size: 40, color: Colors.white),
        ),
      ),
    );
  }
}

void _showInforUser(BuildContext context, Offset position) async {
  final user = FirebaseAuth.instance.currentUser;
  final selected = await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
    items:
        user != null
            ? [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('Thông tin cá nhân'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Đăng xuất'),
              ),
            ]
            : [
              const PopupMenuItem<String>(
                value: 'login',
                child: Text('Đăng nhập'),
              ),
              const PopupMenuItem<String>(
                value: 'sign in',
                child: Text('Đăng kí'),
              ),
            ],
  );
  if (selected != null) {
    if (selected == 'profile') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileUser()),
      );
    } else if (selected == 'logout') {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Background()),
      );
    } else if(selected == 'sign in'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()),
      );
    }else if (selected =='login'){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }
}
