import 'package:flutter/material.dart';
import 'package:monies/data/expensesDataStore.dart';
import 'package:provider/provider.dart';

class TestWidget extends StatelessWidget {
  final Widget child;
  final ExpensesDataStore expensesProvider;
  TestWidget({this.child, this.expensesProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<ExpensesDataStore>(
        create: (context) => expensesProvider,
        child: child,
      ),
    );
  }
}
