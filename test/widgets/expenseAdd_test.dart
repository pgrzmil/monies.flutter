import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/widgets/expenses/expenseAdd.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/testWidget.dart';

void main() {
  ExpensesProvider expensesProvider;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    expensesProvider = ExpensesProvider();
  });

  tearDown(() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.clear();
  });

  testWidgets('Adds expense', (WidgetTester tester) async {
    await tester.pumpWidget(TestWidget(child: ExpenseAddView(), expensesProvider: expensesProvider));

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

    final addedExpense = (await expensesProvider.getAll()).first;
    expect(addedExpense.title, equals("test title"));
    expect(addedExpense.location, equals("test location"));
    expect("${addedExpense.amount}", equals("543.21"));
  });
}
