import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:provider/provider.dart';
import 'expenseForm.dart';

class ExpenseEditView extends StatelessWidget {
  final Expense expense;

  ExpenseEditView({this.expense});

  @override
  Widget build(BuildContext context) {
    final expenseForm = ExpenseForm(expense);
    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<ExpensesProvider>(context, listen: false).remove(expense);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: expenseForm,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = expenseForm.formKey.currentState;
          if (form.validate()) {
            form.save();
            Provider.of<ExpensesProvider>(context, listen: false).edit(expense);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
