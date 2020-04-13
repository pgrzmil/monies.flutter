import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:provider/provider.dart';
import 'expenseForm.dart';

class ExpenseEditView extends StatefulWidget {
  final Expense expense;

  ExpenseEditView({this.expense});

  @override
  _ExpenseEditViewState createState() => _ExpenseEditViewState(formKey: GlobalKey<FormState>(), expense: expense);
}

class _ExpenseEditViewState extends State<ExpenseEditView> {
  final GlobalKey<FormState> formKey;
  Expense expense;

  _ExpenseEditViewState({this.formKey, this.expense});

  @override
  Widget build(BuildContext context) {
    final expenseForm = ExpenseForm(expense, formKey);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(expense.title.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              if (await Dialogs.confirmation(context, text: "Do you want to remove expense?")) {
                await Provider.of<ExpensesProvider>(context, listen: false).remove(expense);
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              if (await Dialogs.confirmation(context, text: "Do you want to reset this recurring expense?", confirmButtonText: "RESET")) {
                final updatedExpense = Provider.of<ExpensesProvider>(context, listen: false).resetOneRecurring(expense);
                setState(() {
                  expense = updatedExpense;
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: expenseForm,
      ),
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
