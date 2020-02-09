import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:provider/provider.dart';
import 'expenseAdd.dart';
import 'expenseEdit.dart';
import './expensesListItem.dart';

class ExpensesList extends StatelessWidget {
  final DateTime selectedDate;

  const ExpensesList({Key key, this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(
      builder: (context, expensesProvider, child) {
        //Add handling state when data is loading
        //return Center(child: CircularProgressIndicator());

        return Scaffold(
          appBar: AppBar(
            title: Text("Expenses"),
          ),
          body: () {
            var expenses = expensesProvider.getForMonth(selectedDate.month, selectedDate.year);
            if (expenses.isEmpty) {
              return Center(child: Text("Start adding expenses"), key: Key("ExpensesList_empty_state"));
            }

            return Card(
              child: ListView.separated(
                  itemCount: expenses.length,
                  separatorBuilder: (context, index) => Divider(height: 7),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseEditView(expense: expenses.elementAt(index)))),
                      child: ExpensesListItem(expenses.elementAt(index)),
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
