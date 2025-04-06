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
    String? userId;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user  == null) {
      WidgetsBinding.instance.addPostFrameCallback( (_){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      });
    }
    else {
      userId = user.uid;
    }
  }

  // Logout function
  Future<void> logout() async {
    setState(() {
      isLogoutLoading =true;
    });
    await FirebaseAuth.instance.signOut();

    if(mounted){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()));
    }
    setState(() {
      isLogoutLoading = false;
    });
  }

  // Show Add Transaction Form dialog
  void _dialoBuilder(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: AddTransactionForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(userId == null){
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () => _dialoBuilder(context),
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
            onPressed: logout,
            icon: isLogoutLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            HeroCard(userId: userId!),
            const TransactionCard(),
          ],
        ),
      ),
    );
  }
}
