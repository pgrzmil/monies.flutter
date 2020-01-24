import 'package:flutter/material.dart';
import 'package:monies/data/expensesDataStore.dart';
import 'package:monies/data/models/expense.dart';

import 'package:provider/provider.dart';

import 'baseWidgets.dart';
import 'expenseEdit.dart';
import 'expensesListItem.dart';

class ExpensesList extends StatelessWidget implements WidgetWithTitle {
  @override
  String get title => "Expenses";

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesDataStore>(builder: (context, expensesProvider, child) {
      return FutureBuilder(
        future: expensesProvider.getAll(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List<Expense> expenses = snapshot.data;
            return Scaffold(
              body: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEditView(expenses[index]))),
                        child: ExpensesListItem(expenses[index]),
                      ),
                    );
                  }),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseAddView()));
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    });
  }
}
