import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'data/expensesDataStore.dart';
import 'widgets/rootTabView.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'monies',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ExpensesDataStore()),
        ],
        child: RootTabView(),
      ),
    );
  }
}
