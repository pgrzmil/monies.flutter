import 'package:flutter/material.dart';
import 'package:monies/data/models/expense.dart';

class ExpenseDetail extends StatefulWidget {
  final Expense expense;

  ExpenseDetail(this.expense);

  @override
  _ExpenseDetailState createState() => _ExpenseDetailState();
}

class _ExpenseDetailState extends State<ExpenseDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense.title),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Container(
            margin: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Title: "),
                    Text(widget.expense.title),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Location: "),
                    Text(widget.expense.location),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Amount: "),
                    Text(widget.expense.amountString),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
