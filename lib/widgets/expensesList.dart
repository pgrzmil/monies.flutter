import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/widgets/expenseDetail.dart';
import 'package:monies/widgets/expensesListItem.dart';

import 'baseWidgets.dart';

class ExpensesList extends StatefulWidget implements WidgetWithTitle {
  final ExpensesProvider expensesProvider;

  ExpensesList(this.expensesProvider);

  @override
  _ExpensesListState createState() => _ExpensesListState();

  @override
  String get title => "Expenses";
}

class _ExpensesListState extends State<ExpensesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: widget.expensesProvider.getAll(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              List<Expense> expenses = snapshot.data;
              return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        onTap: () => navigateToDetails(expenses[index]),
                        child: ExpensesListItem(expenses[index]),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
      );
  }

  void navigateToDetails(Expense expense) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExpenseDetail(expense)));
  }
}
