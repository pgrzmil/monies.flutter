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
    return Consumer<ExpensesProvider>(
      builder: (context, expensesProvider, child) {
        //Add handling state when data is loading
        //return Center(child: CircularProgressIndicator());

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: () {
            List<Expense> expenses = expensesProvider.getAll();
            if (expenses.length == 0) {
              return Center(child: Text("Start adding expenses"), key: Key("ExpensesList_empty_state"));
            }

            return Card(
              child: ListView.separated(
                  itemCount: expenses.length,
                  separatorBuilder: (context, index) => Divider(height: 7),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEditView(expense: expenses[index]))),
                      child: ExpensesListItem(expenses[index]),
                    );
                  }),
            );
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
  }
}
