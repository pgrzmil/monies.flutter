import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/expensesDataStore.dart';
import 'package:monies/widgets/expenses/expenseEdit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/expensesDataStoreHelpers.dart';
import '../testWidget.dart';

void main() {
  ExpensesDataStore expensesProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    expensesProvider = ExpensesDataStore();
    ExpensesDataStoreHelpers.loadExpensesFromFile(expensesProvider, 'assets/mockExpenses.json');
  });

  tearDown(() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  });

  testWidgets('Remove expense test', (WidgetTester tester) async {
    final expense = (await expensesProvider.getAll()).first;

    await tester.pumpWidget(TestWidget(child: ExpenseEditView(expense: expense), expensesProvider: expensesProvider));

    expect((await expensesProvider.getAll()).length, equals(5));

    final removeButton = find.byIcon(Icons.delete);
    expect(removeButton, findsOneWidget);

    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    expect((await expensesProvider.getAll()).length, equals(4));
  });

  testWidgets('Edit expense test', (WidgetTester tester) async {
    final expense = (await expensesProvider.getAll()).first;

    await tester.pumpWidget(TestWidget(child: ExpenseEditView(expense: expense), expensesProvider: expensesProvider));

    final titleTextField = find.byWidgetPredicate((widget) => widget is TextFormField && widget.initialValue == expense.title);
    expect(titleTextField, findsOneWidget);
    await tester.enterText(titleTextField, "test title");

    final locationTextField = find.byWidgetPredicate((widget) => widget is TextFormField && widget.initialValue == expense.location);
    expect(locationTextField, findsOneWidget);
    await tester.enterText(locationTextField, "test location");

    final amountTextField = find.byWidgetPredicate((widget) => widget is TextFormField && widget.initialValue == "${expense.amount}");
    expect(amountTextField, findsOneWidget);
    await tester.enterText(amountTextField, "543.21");

    final saveButton = find.byIcon(Icons.save);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final editedExpense = expensesProvider.getBy(id: expense.id);
    expect(editedExpense.title, equals("test title"));
    expect(editedExpense.location, equals("test location"));
    expect("${editedExpense.amount}", equals("543.21"));
  });
}
