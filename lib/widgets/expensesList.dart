import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/widgets/expenseDetail.dart';
import 'package:monies/widgets/expensesListItem.dart';

class ExpensesList extends StatefulWidget {
  final ExpensesProvider expensesProvider = ExpensesProvider();

  ExpensesList();

  @override
  _ExpensesListState createState() => _ExpensesListState();
}

class _ExpensesListState extends State<ExpensesList> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses"),
      ),
      body: Center(
        child: new FutureBuilder(
          future: widget.expensesProvider.getAll(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              List<Expense> expenses = snapshot.data;
              return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        onTap: () => navigateToDetails(expenses[index]),
                        child: ExpensesListItem(expenses[index]),
                      ),
                    );
                  });
            } else {
              return new Center(child: new CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  void navigateToDetails(Expense expense) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ExpenseDetail(expense)));
  }
}
