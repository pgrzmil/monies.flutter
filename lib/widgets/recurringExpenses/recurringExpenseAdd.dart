import 'package:flutter/material.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/services/signInService.dart';
import 'package:provider/provider.dart';
import 'recurringExpenseForm.dart';

class RecurringExpenseAddView extends StatefulWidget {
  @override
  _RecurringExpenseAddViewState createState() => _RecurringExpenseAddViewState(formKey: GlobalKey<FormState>());
}

class _RecurringExpenseAddViewState extends State<RecurringExpenseAddView> {
  final GlobalKey<FormState> formKey;

  _RecurringExpenseAddViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<SignInService>(context, listen: false).userId;
    final recurringExpense = RecurringExpense.empty(userId);
    final recurringExpenseForm = RecurringExpenseForm(recurringExpense: recurringExpense, formKey: formKey);

    return Scaffold(
      appBar: AppBar(
        title: Text("Add recurring expense"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: recurringExpenseForm,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = recurringExpenseForm.formKey.currentState;
          if (form.validate()) {
            form.save();
            Provider.of<RecurringExpensesProvider>(context, listen: false).add(recurringExpense);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
