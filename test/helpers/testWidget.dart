import 'package:flutter/material.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:provider/provider.dart';

class TestWidget extends StatelessWidget {
  final Widget child;
  final ExpensesProvider expensesProvider;
  TestWidget({this.child, this.expensesProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<ExpensesProvider>(
        create: (context) => expensesProvider,
        child: child,
      ),
    );
  }
}
