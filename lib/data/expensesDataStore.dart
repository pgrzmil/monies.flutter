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

  updateWith(Expense expense) {
    if (!_contains(expense)) {
      _expenses.add(expense);
    }
    save();
    notifyListeners();
  }

  remove(Expense expense) {
    if (_contains(expense)) {
      _expenses.remove(expense);
      save();
      notifyListeners();
    }
  }

  save() async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setStringList(_storeKey, _expenses.map((expense) => expense.toJsonString()).toList());
  }

  bool _contains(Expense expense) => _expenses.any((e) => e.id == expense.id);
}
