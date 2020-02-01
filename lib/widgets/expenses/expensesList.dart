import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';

import 'package:provider/provider.dart';

import '../baseWidgets.dart';
import 'expenseAdd.dart';
import 'expenseEdit.dart';
import './expensesListItem.dart';

class ExpensesList extends StatelessWidget implements WidgetWithTitle {
  @override
  String get title => "Expenses";

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(builder: (context, expensesProvider, child) {
      return FutureBuilder(
        future: expensesProvider.getAll(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            body: () {
              List<Expense> expenses = snapshot.data;
              if (expenses.length == 0) {
                //Empty state
                return Center(child: Text("Start adding expenses"));
              }

              return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEditView(expense: expenses[index]))),
                        child: ExpensesListItem(expenses[index]),
                      ),
                    );
                  });
            }(),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseAddView()));
              },
            ),
          );
        },
      );
    });
  }
}
