import 'package:flutter/material.dart';
import 'package:monies/data/models/income.dart';

class IncomesListItem extends StatelessWidget {
  final Income income;

  IncomesListItem({this.income});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(income.title, style: TextStyle(fontSize: 16)),
        subtitle: Text(income.dateString),
        trailing: Text(income.amountString, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
