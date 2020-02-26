import 'package:flutter/material.dart';
import 'package:monies/data/analyticsProvider.dart';
import 'package:monies/data/dashboardProvider.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/widgets/dashboard.dart';
import 'package:provider/provider.dart';
import 'data/categoriesProvider.dart';
import 'data/expensesProvider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IncomesProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => RecurringExpensesProvider()),
        ChangeNotifierProxyProvider<RecurringExpensesProvider, ExpensesProvider>(
          create: (context) => ExpensesProvider(),
          update: (context, recurringExpensesProvider, expensesProvider) {
            expensesProvider.recurringExpensesProvider = recurringExpensesProvider;
            return expensesProvider;
          },
        ),
        ChangeNotifierProxyProvider2<ExpensesProvider, IncomesProvider, DashboardProvider>(
          create: (context) => DashboardProvider(),
          update: (context, expensesProvider, incomesProvider, dashboardProvider) {
            return dashboardProvider.setProviders(expensesProvider: expensesProvider, incomesProvider: incomesProvider);
          },
        ),
        ChangeNotifierProxyProvider2<ExpensesProvider, CategoriesProvider, AnalyticsProvider>(
          create: (context) => AnalyticsProvider(),
          update: (context, expensesProvider, categoriesProvider, dashboardProvider) {
            return dashboardProvider.setProviders(expensesProvider: expensesProvider, categoriesProvider: categoriesProvider);
          },
        )
      ],
      child: MaterialApp(
        title: 'monies',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        home: Dashboard(),
      ),
    );
  }
}
