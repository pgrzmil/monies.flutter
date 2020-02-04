import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/testDataHelpers.dart';
import 'package:monies/widgets/expenses/expenseEdit.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    preferences.clear();
  });

  testWidgets('Removes expense', (WidgetTester tester) async {
    final expense = (await expensesProvider.getAll()).first;

    await tester.pumpWidget(TestWidget(child: ExpenseEditView(expense: expense), expensesProvider: expensesProvider));

    expect((await expensesProvider.getAll()).length, equals(5));

    final removeButton = find.byIcon(Icons.delete);
    expect(removeButton, findsOneWidget);

    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    expect((await expensesProvider.getAll()).length, equals(4));
  });

  testWidgets('Edits expense', (WidgetTester tester) async {
    final expense = (await expensesProvider.getAll()).first;

    await tester.pumpWidget(TestWidget(child: ExpenseEditView(expense: expense), expensesProvider: expensesProvider));

    final titleTextField = find.byWidgetPredicate((widget) => widget is TextFormField && widget.key == Key("titleField"));
    expect(titleTextField, findsOneWidget);
    await tester.enterText(titleTextField, "test title");

    final locationTextField = find.byWidgetPredicate((widget) => widget is TextFormField && widget.key == Key("locationField"));
    expect(locationTextField, findsOneWidget);
    await tester.enterText(locationTextField, "test location");

    final amountTextField = find.byWidgetPredicate((widget) => widget is TextFormField && widget.key == Key("amountField"));
    expect(amountTextField, findsOneWidget);
    await tester.enterText(amountTextField, "543.21");

    final saveButton = find.byIcon(Icons.save);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final editedExpense = await expensesProvider.getBy(id: expense.id);
    expect(editedExpense.title, equals("test title"));
    expect(editedExpense.location, equals("test location"));
    expect("${editedExpense.amount}", equals("543.21"));
  });
}
