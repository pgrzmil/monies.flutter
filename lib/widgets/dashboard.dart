import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:monies/data/dashboardProvider.dart';
import 'package:monies/utils/formatters.dart';
import 'package:monies/widgets/controls/swipeable.dart';
import 'package:monies/widgets/expenses/expensesEmptyState.dart';
import 'package:monies/widgets/incomes/incomesList.dart';
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
            child: Row(
              //Month selector widget
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
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Settings())),
            ),
          ],
        ),
        body: Swipeable(
          onLeftSwipe: dashboardProvider.switchToPreviousMonth,
          onRightSwipe: dashboardProvider.switchToNextMonth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //dashboard widget
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        children: [
                          Text(Format.money(dashboardProvider.balance), style: TextStyle(fontSize: 36)),
                          Text("Balance", style: TextStyle(fontSize: 10)),
                          Text(Format.money(dashboardProvider.expensesSum), style: TextStyle(fontSize: 26)),
                          Text("Expenses sum", style: TextStyle(fontSize: 10)),
                          InkWell(
                            child: Column(
                              children: [
                                Text(Format.money(dashboardProvider.incomesSum), style: TextStyle(fontSize: 26)),
                                Text("Incomes sum", style: TextStyle(fontSize: 10)),
                              ],
                            ),
                            onTap: () => Navigator.push(
                                context, MaterialPageRoute(builder: (context) => IncomesList(selectedDate: dashboardProvider.currentDate))),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //Expenses widget
              Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: InkWell(
                    child: Column(
                      children: [
                        Text("Expenses"),
                        () {
                          final expenses = dashboardProvider.lastExpenses;
                          if (expenses.isEmpty) {
                            return ExpensesEmptyState();
                          }

                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: expenses.length,
                            padding: EdgeInsets.only(bottom: 5),
                            separatorBuilder: (context, index) => Divider(height: 0),
                            itemBuilder: (context, index) {
                              return ExpensesListItem(expenses.elementAt(index));
                            },
                          );
                        }()
                      ],
                    ),
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ExpensesList(selectedDate: dashboardProvider.currentDate))),
                  ),
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
        ),
      );
    });
  }
}
