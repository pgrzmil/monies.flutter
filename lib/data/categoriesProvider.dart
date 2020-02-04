import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/category.dart';

class CategoriesProvider extends ChangeNotifier {
  final List<ExpenseCategory> _categories = [];
  final String _storeKey = "Categories";

  CategoriesProvider() {
    _load();
  }

  List<ExpenseCategory> getAll() => _categories;

  Future<List<ExpenseCategory>> getAllAsync() async {
    await _load();
    return Future.value(_categories);
  }

  ExpenseCategory getBy({String id}) => _categories.firstWhere((x) => x.id == id, orElse: () => null);

  Future<ExpenseCategory> getByAsync({String id}) async {
    await _load();
    return Future.value(_categories.firstWhere((x) => x.id == id, orElse: () => null));
  }

  String titleFor({String id}) => _categories.firstWhere((x) => x.id == id, orElse: () => null)?.title;

  add(ExpenseCategory category) {
    if (_isNotNull(category) && !_contains(category)) {
      _categories.add(category);
      _persist();
      notifyListeners();
    }
  }

  edit(ExpenseCategory category) {
    if (_isNotNull(category) && _contains(category)) {
      //Expense reference is passed to widgets hence edit method only needs to store and notify about changes
      _persist();
      notifyListeners();
    }
  }

  remove(ExpenseCategory category) {
    if (_isNotNull(category) && _contains(category)) {
      _categories.remove(category);
      _persist();
      notifyListeners();
    }
  }

  bool _contains(ExpenseCategory category) => _categories.any((e) => e.id == category.id);
  bool _isNotNull(ExpenseCategory category) => category != null;

// Persistence methods
  _load() async {
    if (_categories.isNotEmpty) return;

    final preferences = await SharedPreferences.getInstance();
    final serializedList = preferences.getStringList(_storeKey);
    if (serializedList != null) {
      final deserializedItems = serializedList.map((jsonString) => ExpenseCategory.fromJsonString(jsonString));
      _categories.addAll(deserializedItems);
      _categories.sort((cat1, cat2) => cat1.order.compareTo(cat2.order));
    }
  }

  Future<bool> _persist() async {
    final serializedList = _categories.map((expense) => expense.toJsonString()).toList();
    final preferences = await SharedPreferences.getInstance();
    return preferences.setStringList(_storeKey, serializedList);
  }
}
