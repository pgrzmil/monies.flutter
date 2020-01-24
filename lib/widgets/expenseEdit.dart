import 'package:flutter/material.dart';
import 'package:monies/data/expensesDataStore.dart';
import 'package:monies/data/models/expense.dart';
import 'package:provider/provider.dart';

class ExpenseAddView extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ExpenseEditView(Expense.empty());
}

class ExpenseEditView extends StatefulWidget {
  final Expense expense;

  ExpenseEditView(this.expense);

  @override
  _ExpenseEditViewState createState() => _ExpenseEditViewState(expense);
}

class _ExpenseEditViewState extends State<ExpenseEditView> {
  final _formKey = GlobalKey<FormState>();
  final Expense expense;

  _ExpenseEditViewState(this.expense);

  @override
  Widget build(BuildContext context) {
    final isEmptyValidator = (value) => value.isEmpty ? "Enter value" : null;
    final numberValidator = (value) => double.tryParse(value) == null ? "Incorrect number" : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(expense.title == "" ? "Add expense" : expense.title),
      ),
      body: Card(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    initialValue: expense.title,
                    validator: isEmptyValidator,
                    decoration: InputDecoration(labelText: "Expense title"),
                    onSaved: (value) => expense.title = value,
                  ),
                  TextFormField(
                    initialValue: expense.location,
                    validator: isEmptyValidator,
                    decoration: InputDecoration(labelText: "Location"),
                    onSaved: (value) => expense.location = value,
                  ),
                  TextFormField(
                    initialValue: "${expense.amount}",
                    validator: numberValidator,
                    decoration: InputDecoration(labelText: "Amount"),
                    onSaved: (value) => expense.amount = double.tryParse(value) ?? 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            Provider.of<ExpensesDataStore>(context, listen: false).update(expense);
            Navigator.pop(context);
            // TODO: Add snackbar while saving
          }
        },
      ),
    );
  }
}
