import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/services/signInService.dart';
import 'package:monies/utils/navigation.dart';
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
      body: Consumer<SignInService>(builder: (context, signInService, _) {
        final userId = signInService.userId;
        return Center(
          child: Column(
            children: [
              RaisedButton(
                child: Text("Add random expense"),
                onPressed: () {
                  final provider = Provider.of<ExpensesProvider>(context, listen: false);
                  TestDataHelpers.addRandomExpense(provider, userId);
                },
              ),
              RaisedButton(
                child: Text("Load test expenses"),
                onPressed: () {
                  final provider = Provider.of<ExpensesProvider>(context, listen: false);
                  TestDataHelpers.loadTestExpenses(provider, userId);
                },
              ),
              RaisedButton(
                child: Text("Load test categories"),
                onPressed: () {
                  final provider = Provider.of<CategoriesProvider>(context, listen: false);
                  TestDataHelpers.loadTestCategories(provider, userId);
                },
              ),
              RaisedButton(
                child: Text("Load test incomes"),
                onPressed: () {
                  final provider = Provider.of<IncomesProvider>(context, listen: false);
                  TestDataHelpers.loadIncomes(provider, userId, forMonth: DateTime.now());
                },
              ),
              RaisedButton(
                child: Text("Load test recurring expenses"),
                onPressed: () {
                  final provider = Provider.of<RecurringExpensesProvider>(context, listen: false);
                  TestDataHelpers.loadTestRecurringExpenses(provider, userId);
                },
              ),
              RaisedButton(
                child: Text("Edit categories"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesList()));
                },
              ),
              RaisedButton(
                child: Text("Sign out"),
                onPressed: () async {
                  await Provider.of<SignInService>(context, listen: false).signOut();
                  await popLogin(context);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
