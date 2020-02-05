import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/testDataHelpers.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Add random expense"),
              onPressed: () {
                final provider = Provider.of<ExpensesProvider>(context, listen: false);
                TestDataHelpers.addRandomExpense(provider);
              },
            ),
            RaisedButton(
              child: Text("Load test expenses"),
              onPressed: () {
                final provider = Provider.of<ExpensesProvider>(context, listen: false);
                TestDataHelpers.loadTestExpenses(provider);
              },
            ),
            RaisedButton(
              child: Text("Load test categories"),
              onPressed: () {
                final provider = Provider.of<CategoriesProvider>(context, listen: false);
                TestDataHelpers.loadTestCategories(provider);
              },
            ),
          ],
        ),
      ),
    );
  }
}
