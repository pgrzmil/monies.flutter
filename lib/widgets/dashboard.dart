import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/widgets/settings.dart';
import 'package:provider/provider.dart';

import 'baseWidgets.dart';
import 'expenses/expensesList.dart';
import 'expenses/expensesListItem.dart';

class Dashboard extends StatelessWidget implements WidgetWithTitle {
  @override
  String get title => "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpensesProvider>(builder: (context, expensesProvider, _) {
      final lastExpenses = expensesProvider.getLatest(3, 2, 2020);
      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //dashboard component
            Center(
              child: Column(
                children: [Text("Expenses sum")],
              ),
            ),

            //Expenses component
            Card(
              child: InkWell(
                child: Column(
                  children: [
                    Text("Expenses"),
                    SizedBox(
                      //temporary fix for render error
                      height: 170,
                      child: ListView.separated(
                        itemCount: lastExpenses.length,
                        separatorBuilder: (context, index) => Divider(height: 5),
                        itemBuilder: (context, index) {
                          return ExpensesListItem(lastExpenses[index]);
                        },
                      ),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesList())),
              ),
            ),

            //analytics component
            Card(
              child: Column(
                children: [
                  Text("Analytics"),
                  SizedBox(height: 100, width: 100, child: Icon(Icons.pie_chart)),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
