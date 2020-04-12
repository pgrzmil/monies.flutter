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
  _ExpenseEditViewState createState() => _ExpenseEditViewState(formKey: GlobalKey<FormState>());
}

class _ExpenseEditViewState extends State<ExpenseEditView> {
  final GlobalKey<FormState> formKey;

  _ExpenseEditViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final expenseForm = ExpenseForm(widget.expense, formKey);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.expense.title.toUpperCase()),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              if (await Dialogs.confirmation(context, text: "Do you want to remove expense?")) {
                await Provider.of<ExpensesProvider>(context, listen: false).remove(widget.expense);
                Navigator.pop(context);
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
            Provider.of<ExpensesProvider>(context, listen: false).edit(widget.expense);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
