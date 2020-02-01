import 'package:flutter/material.dart';
import 'package:monies/data/models/expense.dart';

class ExpenseForm extends StatefulWidget {
  final Expense expense;
  GlobalKey<FormState> formKey;

  ExpenseForm(this.expense);

  @override
  _ExpenseFormState createState() {
    formKey = GlobalKey<FormState>();
    return _ExpenseFormState();
  }
}

class _ExpenseFormState extends State<ExpenseForm> {
  @override
  Widget build(BuildContext context) {
    final isEmptyValidator = (value) => value.isEmpty ? "Enter value" : null;
    final numberValidator = (value) => double.tryParse(value) == null ? "Incorrect number" : null;

    return Card(
      child: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: widget.expense.title,
                  validator: isEmptyValidator,
                  decoration: InputDecoration(labelText: "Expense title"),
                  onSaved: (value) => widget.expense.title = value,
                ),
                TextFormField(
                  initialValue: widget.expense.location,
                  validator: isEmptyValidator,
                  decoration: InputDecoration(labelText: "Location"),
                  onSaved: (value) => widget.expense.location = value,
                ),
                TextFormField(
                  initialValue: "${widget.expense.amount}",
                  validator: numberValidator,
                  decoration: InputDecoration(labelText: "Amount"),
                  onSaved: (value) => widget.expense.amount = double.tryParse(value) ?? 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
