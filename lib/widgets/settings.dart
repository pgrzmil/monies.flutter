import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/utils/testDataHelpers.dart';
import 'package:monies/widgets/categories/categoriesList.dart';
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
          children: [
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
            RaisedButton(
              child: Text("Load test incomes"),
              onPressed: () {
                final provider = Provider.of<IncomesProvider>(context, listen: false);
                TestDataHelpers.loadIncomes(provider, forMonth: DateTime.now());
              },
            ),
            RaisedButton(
              child: Text("Edit categories"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesList()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
