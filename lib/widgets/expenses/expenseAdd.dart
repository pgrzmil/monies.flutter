import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/services/signInService.dart';
import 'package:provider/provider.dart';
import 'expenseForm.dart';

class ExpenseAddView extends StatefulWidget {
  final DateTime currentDate;

  const ExpenseAddView({Key key, this.currentDate}) : super(key: key);

  @override
  _ExpenseAddViewState createState() => _ExpenseAddViewState(formKey: GlobalKey<FormState>());
}

class _ExpenseAddViewState extends State<ExpenseAddView> {
  final GlobalKey<FormState> formKey;

  _ExpenseAddViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<SignInService>(context, listen: false).userId;
    final Expense expense = Expense.empty(userId);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Add expense".toUpperCase()),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ExpenseForm(
          expense: expense,
          formKey: formKey,
          currentDate: widget.currentDate,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = formKey.currentState;
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
