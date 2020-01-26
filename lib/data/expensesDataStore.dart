import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/expense.dart';

class ExpensesDataStore extends ChangeNotifier {
  final List<Expense> _expenses = [];
  final String _storeKey = "Expenses";

  Future<List<Expense>> getAll() async {
    if (_expenses.length == 0) {
      final preferences = await SharedPreferences.getInstance();
      final serializedExpenses = preferences.getStringList(_storeKey);

      if (serializedExpenses != null) {
        _expenses.addAll(serializedExpenses.map((jsonString) => Expense.fromJsonString(jsonString)));
      }
    }
    return Future.value(_expenses);
  }

  updateWith(Expense expense) async {
    if (!_expenses.any((e) => e.id == expense.id)) {
      _expenses.add(expense);
    }
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList(_storeKey, _expenses.map((expense) => expense.toJsonString()).toList());
    notifyListeners();
  }
}
