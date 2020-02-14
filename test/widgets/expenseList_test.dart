import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/widgets/expenses/expenseAdd.dart';
import 'package:monies/widgets/expenses/expenseEdit.dart';
import 'package:monies/widgets/expenses/expensesEmptyState.dart';
import 'package:monies/widgets/expenses/expensesList.dart';
import 'package:monies/widgets/expenses/expensesListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monies/utils/testDataHelpers.dart';
import '../helpers/testWidget.dart';

void main() {
  ExpensesProvider expensesProvider;
  
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    expensesProvider = ExpensesProvider();
    TestDataHelpers.loadTestExpenses(expensesProvider);
  });

  tearDown(() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  });

  testWidgets('Shows list view with loaded expenses', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpensesList(selectedDate: DateTime(2019, 12, 1)), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    expect(find.byType(ExpensesListItem), findsNWidgets(5));

    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
  });

  testWidgets('Shows empty expenses list', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await expensesProvider.clear();
      await tester.pumpWidget(TestWidget(child: ExpensesList(selectedDate: DateTime(2019, 12, 1)), expensesProvider: expensesProvider));
      await tester.pumpAndSettle(Duration(milliseconds: 500)); //wait for Future builder to finish

      expect(find.byWidgetPredicate((widget) => widget.key == Key("expensesList_empty_state")), findsOneWidget);
      expect(find.byType(ExpensesEmptyState), findsOneWidget);
      expect(find.byType(ExpensesListItem), findsNothing);

      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
    });
  });

  testWidgets('Returns expenses floating button', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpensesList(selectedDate: DateTime(2019, 12, 1)), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);
  });

  testWidgets('Navigates to add view after tapping floating button', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpensesList(selectedDate: DateTime(2019, 12, 1)), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    final addButton = find.byIcon(Icons.add);
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    expect(find.byType(ExpenseAddView), findsOneWidget);
  });

  testWidgets('Navigates to edit view after tapping any list item', (WidgetTester tester) async {
    final random = Random();

    await tester.pumpWidget(TestWidget(child: ExpensesList(selectedDate: DateTime(2019, 12, 1)), expensesProvider: expensesProvider));
    await tester.pumpAndSettle(); //wait for Future builder to finish

    final listItems = find.byType(ExpensesListItem);
    expect(listItems, findsNWidgets(5));

    final randomListItem = listItems.at(random.nextInt(5));
    expect(randomListItem, findsOneWidget);

    await tester.tap(randomListItem);
    await tester.pumpAndSettle();

    expect(find.byType(ExpenseEditView), findsOneWidget);
  });
}
