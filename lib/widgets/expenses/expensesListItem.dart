import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:provider/provider.dart';
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
            Consumer<CategoriesProvider>(builder: (context, provider, child) {
              final category = provider.getBy(id: expense.categoryId);
              return Container(
                padding: EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  backgroundColor: category?.color ?? Colors.deepPurple[500],
                  child: Icon(category?.icon ?? Icons.attach_money, color: Colors.white,),
                ),
              );
            }),
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
