import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:monies/data/dashboardProvider.dart';
import 'package:monies/widgets/controls/swipeable.dart';
import 'package:monies/widgets/dashboard/balanceCard.dart';
import 'package:monies/widgets/dashboard/expensesCard.dart';
import 'package:monies/widgets/incomes/incomesList.dart';
import 'package:monies/widgets/settings.dart';
import 'package:monies/utils/navigation.dart';
import 'package:monies/widgets/signIn.dart';
import 'package:provider/provider.dart';

import '../analytics/analyticsDashboard.dart';
import '../expenses/expensesList.dart';
import 'analyticsCard.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final service = Provider.of<SignInService>(context, listen: false);
      final isLoggedIn = await service.isLoggedIn();
      if(!isLoggedIn){
        await Navigator.pushNamed(context, Routes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, dashboardProvider, _) {
      return Scaffold(
        appBar: AppBar(
          title: Row(
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
      );
    });
  }
}
