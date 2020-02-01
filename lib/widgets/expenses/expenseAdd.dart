import 'package:flutter/material.dart';
import 'package:monies/data/expensesDataStore.dart';
import 'package:monies/data/models/expense.dart';
import 'package:provider/provider.dart';
import 'expenseForm.dart';

class ExpenseAddView extends StatelessWidget {
  final Expense expense = Expense.empty();

  @override
  Widget build(BuildContext context) {
    final expenseForm = ExpenseForm(expense);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add expense"),
      ),
      body: expenseForm,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = expenseForm.formKey.currentState;
          if (form.validate()) {
            form.save();
            Provider.of<ExpensesDataStore>(context, listen: false).add(expense);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
