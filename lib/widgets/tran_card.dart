import 'package:cost_management/utils/icon_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


class TranCard extends StatelessWidget {
  TranCard({super.key, required this.data});

  var appIcons = AppIcons();
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              color: Colors.green.withOpacity(0.2),
              blurRadius: 10.0,
              spreadRadius: 4.0,
            ),
          ],
        ),

        child: ListTile(
          minVerticalPadding: 10,
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
          leading: SizedBox(
            width: 70,
            height: 100,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: data['type'] == 'Credit' ?
                      Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
              ),
              child: Center(
                child: FaIcon(appIcons.getExpenseCategoryIcons("${data['category']}"),
                color: data['type'] == 'Credit' ? Colors.green : Colors.red,),

              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(child: Text("${data['title']}")),
              Text("${data['type'] == 'Credit' ? '+' : '-'} ${data['amount']}", style: TextStyle(color: data['type'] == 'Credit' ? Colors.green : Colors.red,),
              ),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Spacer(),
                  Text(
                    "${data['amount']}",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              Text("${data['timestamp']}", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
