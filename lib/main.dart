import 'package:cost_management/home/background.dart';
import 'package:cost_management/home/dashboard.dart';
import 'package:cost_management/home/home_screen.dart';
import 'package:cost_management/screens/login_screen.dart';
import 'package:cost_management/screens/sign_up.dart';
import 'package:cost_management/widgets/auth_gate.dart';
import 'package:cost_management/widgets/transaction_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cost management',
      builder: (context,child){
        return MediaQuery(data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
            child: child!);
      },
      debugShowCheckedModeBanner: false,
      home: BackGround(),
    );
  }
}


