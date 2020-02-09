import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:monies/data/dashboardProvider.dart';
import 'package:monies/widgets/settings.dart';
import 'package:provider/provider.dart';

import 'expenses/expensesList.dart';
import 'expenses/expensesListItem.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dashboardProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Row( //Month selector widget
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  child: Icon(Icons.arrow_left),
                  onPressed: dashboardProvider.switchToPreviousMonth,
                ),
                Text(dashboardProvider.title),
                FlatButton(
                  child: Icon(Icons.arrow_right),
                  onPressed: dashboardProvider.switchToNextMonth,
                ),
              ],
            ),
          ),
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
            //dashboard widget
            Center(
              child: Column(
                children: [Text("Expenses sum")],
              ),
            ),

            //Expenses widget
            Card(
              child: InkWell(
                child: Column(
                  children: [
                    Text("Expenses"),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dashboardProvider.lastExpenses.length,
                      padding: EdgeInsets.only(bottom: 5),
                      separatorBuilder: (context, index) => Divider(height: 5),
                      itemBuilder: (context, index) {
                        return ExpensesListItem(dashboardProvider.lastExpenses.elementAt(index));
                      },
                    ),
                  ],
                ),
                onTap: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesList(selectedDate: dashboardProvider.currentDate))),
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
