import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget{
  const TransactionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                  "Recent Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index) {
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 10),
                              color: Colors.grey.withOpacity(0.09),
                              blurRadius: 10.0,
                              spreadRadius: 4.0
                          )
                        ]
                    ),

                    child: ListTile(
                      title: Row(
                        children: [
                          Text("Car rent Oct 2023"),
                          Text("100",
                            style: TextStyle(color: Colors.green),)
                        ],
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text("Balance", style: TextStyle(
                                color: Colors.grey, fontSize: 13)),
                            Spacer(),
                            Text("250", style: TextStyle(
                                color: Colors.grey, fontSize: 13),
                            ),
                          ],),
                          Text("25 oct 2025",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                );
              }
          ),
        ],
      ),
    );
  }
}