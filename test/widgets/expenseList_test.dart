import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/widgets/baseWidgets.dart';
import 'package:monies/widgets/expenses/expenseAdd.dart';
import 'package:monies/widgets/expenses/expenseEdit.dart';
import 'package:monies/widgets/expenses/expensesList.dart';
import 'package:monies/widgets/expenses/expensesListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/expensesProviderHelpers.dart';
import '../helpers/testWidget.dart';

void main() {
  ExpensesProvider expensesProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    expensesProvider = ExpensesProvider();
    ExpensesProviderHelpers.loadExpensesFromFile(expensesProvider, 'assets/mockExpenses.json');
  });

  tearDown(() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  });

  testWidgets('Shows list view with loaded expenses', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpensesList(), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    expect(find.byType(ExpensesListItem), findsNWidgets(5));

    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
  });

  testWidgets('Shows empty expenses list', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final expenses = await expensesProvider.getAll();
      while (expenses.length != 0) {
        expensesProvider.remove(expenses[0]);
      } //clear expenses list
      await tester.pumpWidget(TestWidget(child: ExpensesList(), expensesProvider: expensesProvider));
      await tester.pumpAndSettle(Duration(milliseconds: 500)); //wait for Future builder to finish

      expect(find.byWidgetPredicate((widget) => widget.key == Key("ExpensesList_empty_state")), findsOneWidget);
      expect(find.byType(ExpensesListItem), findsNothing);

      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
    });
  });

  testWidgets('Returns progress indicator on loading expenses', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpensesList(), expensesProvider: expensesProvider));
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Returns expenses floating button', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpensesList(), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
  });

  testWidgets('Navigates to add view after tapping floating button', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpensesList(), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.byType(ExpenseAddView), findsOneWidget);
  });

  testWidgets('Navigates to edit view after tapping any list item', (WidgetTester tester) async {
    final random = new Random();
    
    await tester.pumpWidget(TestWidget(child: ExpensesList(), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    final listItems = find.byType(ExpensesListItem);
    expect(listItems, findsNWidgets(5));

    final randomListItem = listItems.at(random.nextInt(5));
    expect(randomListItem, findsOneWidget);

    await tester.tap(randomListItem);
    await tester.pumpAndSettle();

    expect(find.byType(ExpenseEditView), findsOneWidget);
  });

  testWidgets('Returns title', (WidgetTester tester) async {
    final widget = ExpensesList();

    expect(widget, isA<WidgetWithTitle>());
    expect(widget.title, equals("Expenses"));
  });
}
