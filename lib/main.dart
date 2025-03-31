import 'package:cost_management/home/Dashboard.dart';
import 'package:cost_management/screens/login_screen.dart';
import 'package:cost_management/screens/sign_up.dart';
import 'package:cost_management/widgets/auth_gate.dart';
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
      debugShowCheckedModeBanner: false,
      home: Dashboard(),
    );
  }
}


