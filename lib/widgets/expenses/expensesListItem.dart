import 'package:flutter/material.dart';
import '../../data/models/expense.dart';

class ExpensesListItem extends StatelessWidget {
  final Expense expense;

  ExpensesListItem(this.expense);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 5),
              child: CircleAvatar(
                backgroundColor: Colors.red[300],
                child: Text("\$"),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(expense.title),
                Text(expense.location),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(expense.amountString),
            ),
          ],
        ),
      ),
    );
  }
}
