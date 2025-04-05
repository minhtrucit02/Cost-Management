import 'package:flutter/material.dart';
import '../utils/icon_list.dart';

class CategoryDropDown extends StatelessWidget {
  CategoryDropDown({super.key, this.cattype, required this.onChanged});

  final String? cattype;
  final ValueChanged<String?> onChanged;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {

    String? selectedValue = appIcons.homeExpensesCategories.any((e) => e['name'] == cattype)
        ? cattype
        : null;

    return DropdownButton<String>(
      value: selectedValue,
      isExpanded: true,
      hint: Text("Select category"),
      items: appIcons.homeExpensesCategories.map((e) {
        return DropdownMenuItem<String>(
          value: e['name'],
          child: Row(
            children: [
              Icon(
                e['icon'],
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                e['name'],
                style: TextStyle(color: Colors.black45),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
