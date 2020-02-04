import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'data/categoriesProvider.dart';
import 'data/expensesProvider.dart';
import 'widgets/rootTabView.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpensesProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
      ],
      child: MaterialApp(
        title: 'monies',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: RootTabView(),
      ),
    );
  }
}
