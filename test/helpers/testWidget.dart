import 'package:flutter/material.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:provider/provider.dart';

class TestWidget extends StatefulWidget {
  final Widget child;
  final ExpensesProvider expensesProvider;
  final CategoriesProvider categoriesProvider;

  TestWidget({this.child, this.expensesProvider, this.categoriesProvider});

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => widget.expensesProvider ?? ExpensesProvider(databaseStorageEnabled: false)),
        ChangeNotifierProvider(create: (context) => widget.categoriesProvider ?? CategoriesProvider(databaseStorageEnabled: false)),
      ],
      child: MaterialApp(
        home: Scaffold(body: widget.child),
      ),
    );
  }
}
