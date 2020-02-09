import 'package:flutter/material.dart';
import 'package:monies/data/dashboardProvider.dart';
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
        ChangeNotifierProvider(create: (context) => ExpensesProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProxyProvider<ExpensesProvider, DashboardProvider>(
          create: (context) => DashboardProvider(null),
          update: (context, expensesProvider, _) => DashboardProvider(expensesProvider),
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
