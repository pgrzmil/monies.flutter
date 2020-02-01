import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:monies/data/expensesProvider.dart';
import 'package:monies/data/models/expense.dart';

class ExpensesProviderHelpers {
  static Expense addRandomExpense(ExpensesProvider expensesProvider) {
    final random = Random();
    final expense = Expense.fromValues("title ${random.nextInt(123)}", "location", random.nextDouble() * 100);
    expensesProvider.add(expense);
    return expense;
  }

  static void loadExpensesFromFile(ExpensesProvider expensesProvider, String path) async {
    String fileContents = await rootBundle.loadString(path);
    if (fileContents == null) return;
    
    final parsed = json.decode(fileContents).cast<Map<String, dynamic>>();
    parsed.forEach((json) => expensesProvider.add(Expense.fromJson(json)));
  }
}
