import 'package:flutter/material.dart';
import 'package:monies/data/models/income.dart';

class IncomesListItem extends StatelessWidget {
  final Income income;
  final void Function() onTap;

  IncomesListItem({this.income, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(income.title, style: TextStyle(fontSize: 16)),
        subtitle: Text(income.dateString),
        trailing: Text(income.amountString, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        onTap: onTap,
      ),
    );
  }
}
