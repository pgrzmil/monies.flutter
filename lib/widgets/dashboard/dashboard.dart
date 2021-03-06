import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:monies/data/dashboardProvider.dart';
import 'package:monies/widgets/controls/swipeable.dart';
import 'package:monies/widgets/dashboard/balanceCard.dart';
import 'package:monies/widgets/dashboard/expensesCard.dart';
import 'package:monies/widgets/incomes/incomesList.dart';
import 'package:monies/widgets/settings.dart';
import 'package:monies/utils/navigation.dart';
import 'package:provider/provider.dart';

import '../analytics/analyticsDashboard.dart';
import '../expenses/expensesList.dart';
import 'analyticsCard.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dashboardProvider, _) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Row(
            //Month selector widget
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                child: Icon(Icons.arrow_left, color: AppBarTheme.of(context).iconTheme.color),
                onPressed: dashboardProvider.switchToPreviousMonth,
              ),
              Text(dashboardProvider.title),
              FlatButton(
                child: Icon(Icons.arrow_right, color: AppBarTheme.of(context).iconTheme.color),
                onPressed: dashboardProvider.switchToNextMonth,
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => pushTo(context, Settings()),
            ),
          ],
        ),
        body: Swipeable(
          onLeftSwipe: dashboardProvider.switchToNextMonth,
          onRightSwipe: dashboardProvider.switchToPreviousMonth,
          child: RefreshIndicator(
            onRefresh: dashboardProvider.refresh,
            child: ListView(
              children: <Widget>[
                BalanceCard(
                  balance: dashboardProvider.balanceText,
                  expenses: dashboardProvider.expensesSumText,
                  incomes: dashboardProvider.incomesSumText,
                  onIncomesTap: () => pushTo(context, IncomesList(selectedDate: dashboardProvider.currentDate)),
                ),
                ExpensesCard(
                  expenses: dashboardProvider.lastExpenses,
                  onTap: () => pushTo(context, ExpensesList(selectedDate: dashboardProvider.currentDate)),
                ),
                AnalyticsCard(
                  chartData: dashboardProvider.categoriesChartDate,
                  chartAnimated: dashboardProvider.categoriesChartAnimated,
                  onTap: () => pushTo(context, AnalyticsDashboard()),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
