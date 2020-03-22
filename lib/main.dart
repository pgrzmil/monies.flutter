import 'package:flutter/material.dart';
import 'package:monies/data/analyticsProvider.dart';
import 'package:monies/data/dashboardProvider.dart';
import 'package:monies/data/incomesProvider.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/utils/navigation.dart';
import 'package:monies/services/signInService.dart';
import 'package:provider/provider.dart';
import 'data/categoriesProvider.dart';
import 'data/expensesProvider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => SignInService()),
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
        ChangeNotifierProxyProvider2<ExpensesProvider, CategoriesProvider, AnalyticsProvider>(
          create: (context) => AnalyticsProvider(),
          update: (context, expensesProvider, categoriesProvider, dashboardProvider) {
            return dashboardProvider.setProviders(expensesProvider: expensesProvider, categoriesProvider: categoriesProvider);
          },
        ),
        ChangeNotifierProxyProvider3<ExpensesProvider, IncomesProvider, AnalyticsProvider, DashboardProvider>(
          create: (context) => DashboardProvider(),
          update: (context, expensesProvider, incomesProvider, analyticsProvider, dashboardProvider) {
            return dashboardProvider.setProviders(
              expensesProvider: expensesProvider,
              incomesProvider: incomesProvider,
              analyticsProvider: analyticsProvider,
            );
          },
        )
      ],
      child: MaterialApp(
        title: 'monies',
        theme: ThemeData(
          primarySwatch: Colors.lime,
        ),
        routes: Routes.navigationRoutes,
        initialRoute: Routes.dashboardLogin,
      ),
    );
  }
}
