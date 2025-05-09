
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Background/Background.dart';
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
      home:Background(),
    );
  }
}


