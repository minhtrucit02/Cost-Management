import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {
      "name": "Gas Filling",
      "icon": FontAwesomeIcons.gasPump,
    },
    {
      "name": "Grocery",
      "icon": FontAwesomeIcons.shoppingCart,
    },
    {
      "name": "Electricity",
      "icon": FontAwesomeIcons.bolt,
    },
    {
      "name": "Water",
      "icon": FontAwesomeIcons.water,
    },
    {
      "name": "Rent",
      "icon": FontAwesomeIcons.home,
    },
  ];

  IconData getExpenseCategoryIcons(String categoryName) {
    return homeExpensesCategories
        .firstWhere(
          (category) => category['name'] == categoryName,
      orElse: () => {"icon": FontAwesomeIcons.question},
    )['icon'] as IconData;
  }
}
