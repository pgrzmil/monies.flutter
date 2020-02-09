import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/utils/testDataHelpers.dart';
import 'package:monies/widgets/expenses/expensesListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/testWidget.dart';

void main() {
  CategoriesProvider categoriesProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    categoriesProvider = CategoriesProvider();
    TestDataHelpers.loadTestCategories(categoriesProvider);
  });

  tearDown(() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  });

  testWidgets('Shows expense list item widget', (WidgetTester tester) async {
    final expense = Expense.fromValues("test title", "test location", 123.45, DateTime(2020, 1, 23), "cat1");
    final category = categoriesProvider.getBy(id: "cat1");

    await tester.pumpWidget(
      TestWidget(
        categoriesProvider: categoriesProvider,
        child: ExpensesListItem(expense)
      ),
    );

    final categoryIcon = find.byWidgetPredicate((widget) => widget is Icon && widget.icon == category.icon);
    expect(categoryIcon, findsOneWidget);

    final categoryBackground = find.byWidgetPredicate((widget) => widget is CircleAvatar && widget.backgroundColor == category.color);
    expect(categoryBackground, findsOneWidget);

    final titleText = find.byWidgetPredicate((widget) => widget is Text && widget.data == expense.displayTitle);
    expect(titleText, findsOneWidget);

    final locationText = find.byWidgetPredicate((widget) => widget is Text && widget.data == expense.dateString);
    expect(locationText, findsOneWidget);

    final amountText = find.byWidgetPredicate((widget) => widget is Text && widget.data == expense.amountString);
    expect(amountText, findsOneWidget);
  });
}
