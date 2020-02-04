import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/models/expense.dart';
import 'package:monies/widgets/expenses/expensesListItem.dart';
import '../helpers/testWidget.dart';

void main() {
  testWidgets('Shows expense list item widget', (WidgetTester tester) async {
    final expense = Expense.fromValues("test title", "test location", 123.45, DateTime(2020, 1, 23));

    await tester.pumpWidget(TestWidget(child: ExpensesListItem(expense)));

    final categoryText = find.byWidgetPredicate((widget) => widget is Text && widget.data == '\$');
    expect(categoryText, findsOneWidget);

    final titleText = find.byWidgetPredicate((widget) => widget is Text && widget.data == expense.title);
    expect(titleText, findsOneWidget);

    final locationText = find.byWidgetPredicate((widget) => widget is Text && widget.data == expense.location);
    expect(locationText, findsOneWidget);

    final amountText = find.byWidgetPredicate((widget) => widget is Text && widget.data == expense.amountString);
    expect(amountText, findsOneWidget);
  });
}
