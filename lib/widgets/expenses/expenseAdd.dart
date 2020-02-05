import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:provider/provider.dart';
import 'expenseForm.dart';

class ExpenseAddView extends StatefulWidget {
  @override
  _ExpenseAddViewState createState() => _ExpenseAddViewState(formKey: GlobalKey<FormState>());
}

class _ExpenseAddViewState extends State<ExpenseAddView> {
  final Expense expense = Expense.empty();
  final GlobalKey<FormState> formKey;

  _ExpenseAddViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final expenseForm = ExpenseForm(expense, formKey);
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
            Provider.of<ExpensesProvider>(context, listen: false).add(expense);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
