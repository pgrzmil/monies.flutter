import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/expense.dart';

class ExpensesDataStore extends ChangeNotifier {
  final List<Expense> _expenses = [];
  final String _storeKey = "Expenses";

  Future<List<Expense>> getAll() async {
    if (_expenses.isEmpty) {
      await _load();
    }
    return Future.value(_expenses);
  }

  Expense getBy({String id}) => _expenses.firstWhere((x) => x.id == id);

  add(Expense expense) {
    if (!_contains(expense)) {
      _expenses.add(expense);
      _persist();
      notifyListeners();
    }
  }

  edit(Expense updatedExpense) {
    //Expense reference is passed to widgets hence edit method only needs to store and notify about changes
    _persist();
    notifyListeners();
  }

  remove(Expense expense) {
    if (_contains(expense)) {
      _expenses.remove(expense);
      _persist();
      notifyListeners();
    }
  }

  bool _contains(Expense expense) => _expenses.any((e) => e.id == expense.id);

// Persistence methods
  _load() async {
    final preferences = await SharedPreferences.getInstance();
    final serializedList = preferences.getStringList(_storeKey);
    if (serializedList != null) {
      final deserializedItems = serializedList.map((jsonString) => Expense.fromJsonString(jsonString));
      _expenses.addAll(deserializedItems);
    }
  }

  Future<bool> _persist() async {
    final serializedList = _expenses.map((expense) => expense.toJsonString()).toList();
    final preferences = await SharedPreferences.getInstance();
    return preferences.setStringList(_storeKey, serializedList);
  }
}
