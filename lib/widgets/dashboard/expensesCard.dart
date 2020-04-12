import 'package:flutter/material.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/widgets/controls/emptyState.dart';
import 'package:monies/widgets/expenses/expensesListItem.dart';

class ExpensesCard extends StatelessWidget {
  final List<Expense> expenses;
  final GestureTapCallback onTap;

  const ExpensesCard({Key key, this.expenses, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        child: InkWell(
          child: Column(
            children: [
              Text("Expenses".toUpperCase(), style: TextStyle(fontWeight: FontWeight.w900)),
              () {
                if (expenses.isEmpty) {
                  return EmptyState(text: "Empty!\nStart adding expenses.");
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  padding: EdgeInsets.only(bottom: 5),
                  separatorBuilder: (context, index) => Divider(height: 0),
                  itemBuilder: (context, index) {
                    return ExpensesListItem(expense: expenses.elementAt(index));
                  },
                );
              }()
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
