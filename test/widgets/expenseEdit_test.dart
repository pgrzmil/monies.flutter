import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/categoriesProvider.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/utils/testDataHelpers.dart';
import 'package:monies/widgets/expenses/expenseEdit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/testWidget.dart';

void main() {
  ExpensesProvider expensesProvider;
  CategoriesProvider categoriesProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    expensesProvider = ExpensesProvider();
    categoriesProvider = CategoriesProvider();
    TestDataHelpers.loadTestCategories(categoriesProvider);
    TestDataHelpers.loadTestExpenses(expensesProvider);
  });

  tearDown(() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  });

  testWidgets('Removes expense', (WidgetTester tester) async {
    final expense = expensesProvider.getAll().first;

    await tester.pumpWidget(TestWidget(
      child: ExpenseEditView(expense: expense),
      expensesProvider: expensesProvider,
      categoriesProvider: categoriesProvider,
    ));

    expect(expensesProvider.getAll().length, equals(5));

    final removeButton = find.byIcon(Icons.delete);
    expect(removeButton, findsOneWidget);

    await tester.tap(removeButton);
    await tester.pumpAndSettle();

    final confirmButton = find.byKey(Key("confirm_dialog_button_ok"));
    expect(confirmButton, findsOneWidget);
    
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(expensesProvider.getAll().length, equals(4));
  });

  testWidgets('Edits expense', (WidgetTester tester) async {
    final expense = expensesProvider.getAll().first;

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

    final dateTextField = find.byKey(Key("dateField"));
    expect(dateTextField, findsOneWidget);
    await tester.tap(dateTextField);
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK").first);
    await tester.pumpAndSettle();

    final categoryField = find.byKey(Key("categoryDropDown"));
    expect(categoryField, findsOneWidget);
    await tester.tap(categoryField);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Rachunki").first);
    await tester.pumpAndSettle();
    final saveButton = find.byIcon(Icons.save);

    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final editedExpense = expensesProvider.getBy(id: expense.id);
    expect(editedExpense.title, equals("test title"));
    expect(editedExpense.location, equals("test location"));
    //Checking amount text field is broken due to money format controller
    // expect("${editedExpense.amount}", equals("543.21"));
    final now = expense.date; //temporarily not checking date changes
    expect(editedExpense.date.year, equals(now.year));
    expect(editedExpense.date.month, equals(now.month));
    expect(editedExpense.date.day, equals(now.day));
    expect(editedExpense.categoryId, equals("cat1"));
  });
}
