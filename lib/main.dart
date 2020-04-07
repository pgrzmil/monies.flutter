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
import 'data/recurringExpensesMapProvider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = SignInService();
    return MultiProvider(
      providers: [
        Provider(create: (context) => authService),
        ChangeNotifierProvider(create: (context) => IncomesProvider(authService: authService)),
        ChangeNotifierProvider(create: (context) => CategoriesProvider(authService: authService)),
        ChangeNotifierProvider(create: (context) => RecurringExpensesMapProvider(authService: authService)),
        ChangeNotifierProvider(create: (context) => RecurringExpensesProvider(authService: authService)),
        ChangeNotifierProxyProvider2<RecurringExpensesProvider, RecurringExpensesMapProvider, ExpensesProvider>(
          create: (context) => ExpensesProvider(authService: authService),
          update: (context, recurringExpensesProvider, recurringExpensesMapProvider, expensesProvider) {
            expensesProvider.recurringExpensesProvider = recurringExpensesProvider;
            expensesProvider.recurringExpensesMapProvider = recurringExpensesMapProvider;
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
          primarySwatch: Colors.indigo,
          primaryColor: Colors.indigo[900],
        ),
        routes: Routes.navigationRoutes,
        initialRoute: Routes.login,
      ),
    );
  }
}
