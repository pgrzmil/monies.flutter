import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/expense.dart';

class ExpensesDataStore extends ChangeNotifier {
  final List<Expense> _expenses = [];
  final String _storeKey = "Expenses";

  Future<List<Expense>> getAll() async {
    if (_expenses.isEmpty) {
      await _loadFromCache();
    }
    return Future.value(_expenses);
  }

  Expense getById(String id) => _expenses.firstWhere((x) => x.id == id);

  _loadFromCache() async {
    final preferences = await SharedPreferences.getInstance();
    final serializedList = preferences.getStringList(_storeKey);
    if (serializedList != null) {
      final deserializedItems = serializedList.map((jsonString) => Expense.fromJsonString(jsonString));
      _expenses.addAll(deserializedItems);
    }
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

  Future<bool> save() async {
    final serializedList = _expenses.map((expense) => expense.toJsonString()).toList();
    final preferences = await SharedPreferences.getInstance();
    return preferences.setStringList(_storeKey, serializedList);
  }

  bool _contains(Expense expense) => _expenses.any((e) => e.id == expense.id);
}
