import 'package:flutter/material.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'package:monies/widgets/controls/dialogs.dart';
import 'package:provider/provider.dart';
import 'recurringExpenseForm.dart';

class RecurringExpenseEditView extends StatefulWidget {
  final RecurringExpense recurringExpense;

  RecurringExpenseEditView({this.recurringExpense});

  @override
  _RecurringExpenseEditViewState createState() => _RecurringExpenseEditViewState(formKey: GlobalKey<FormState>());
}

class _RecurringExpenseEditViewState extends State<RecurringExpenseEditView> {
  final GlobalKey<FormState> formKey;

  _RecurringExpenseEditViewState({this.formKey});

  @override
  Widget build(BuildContext context) {
    final recurringExpenseForm = RecurringExpenseForm(recurringExpense: widget.recurringExpense, formKey: formKey);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recurringExpense.title),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              if (await Dialogs.confirmation(context, text: "Do you want to remove recurring expense?")) {
                await Provider.of<RecurringExpensesProvider>(context, listen: false).remove(widget.recurringExpense);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child:recurringExpenseForm,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = recurringExpenseForm.formKey.currentState;
          if (form.validate()) {
            form.save();
            Provider.of<RecurringExpensesProvider>(context, listen: false).edit(widget.recurringExpense);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
