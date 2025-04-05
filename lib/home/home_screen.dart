import 'package:cost_management/widgets/add_transaction_form.dart';
import 'package:cost_management/widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_screen.dart';
import '../widgets/card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoading = false;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Check if user is authenticated on initial screen load
  @override
  void initState() {
    super.initState();

    // Redirect to Login screen if no user is logged in
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  // Logout function
  logout() async {
    setState(() {
      isLogoutLoading = true;
    });
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );

    setState(() {
      isLogoutLoading = false;
    });
  }

  // Show Add Transaction Form dialog
  _dialoBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const AddTransactionForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () {
          _dialoBuilder(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          "Cost Management",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: isLogoutLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            HeroCard(userId: userId),
            const TransactionCard(),
          ],
        ),
      ),
    );
  }
}
