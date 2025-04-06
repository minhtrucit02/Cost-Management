
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: usersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          print(usersStream);
          return const Center(child: Text("Document does not exist"));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        return Cards(data: data);
      },
    );
  }
}

class Cards extends StatelessWidget{
  const Cards({super.key, required this.data});

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total balance',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  '${data['remainingAmount']}',
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                CardOne(color: Colors.green,heading: 'Credit',amount: "${data['totalCredit']}",),
                SizedBox(width: 10),
                CardOne(color: Colors.red,heading: 'Debit',amount: "${data['totalDebit']}",),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardOne extends StatelessWidget {
  const CardOne({super.key, required this.color, required this.heading, required this.amount});
  final Color color;
  final String heading;
  final String amount;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading, style: TextStyle(color: color, fontSize: 15)),
                  Text(
                    amount,
                    style: TextStyle(
                      color: color,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                    heading == 'Credit'?
                    Icons.arrow_upward_outlined : Icons.arrow_downward_outlined, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
