import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/baseModel.dart';

typedef T ItemJsonSerializator<T>(String jsonString);

abstract class BaseStorageProvider<T extends BaseModel> extends ChangeNotifier {
  final List<T> items = [];
  final String storeKey;

  ///Item's json deserializing method.
  ///
  ///There is no way to use item constructor or static method from generic type abstract
  ///class so creator function is passed as parameter to super constructor.
  final ItemJsonSerializator<T> fromJsonString;

  BaseStorageProvider({this.storeKey, this.fromJsonString}) {
    _load();
  }

  List<T> getAll() => items;

  T getBy({String id}) => items.firstWhere((x) => x.id == id, orElse: () => null);

  Future add(T item) async {
    if (_isNotNull(item) && !_contains(item)) {
      items.add(item);
      notifyListeners();
      await _persist();
    }
  }

  Future edit(T item) async {
    if (_isNotNull(item) && _contains(item)) {
      //item reference is passed to widgets hence edit method only needs to store and notify about changes
      notifyListeners();
      await _persist();
    }
  }

  Future remove(T item) async {
    if (_isNotNull(item) && _contains(item)) {
      items.remove(item);
      notifyListeners();
      await _persist();
    }
  }

  bool _contains(T item) => items.any((e) => e.id == item.id);
  bool _isNotNull(T item) => item != null;

// Persistence methods
  _load() async {
    if (items.isNotEmpty) return;

    final preferences = await SharedPreferences.getInstance();
    final serializedList = preferences.getStringList(storeKey);
    if (serializedList != null) {
      final deserializedItems = serializedList.map((jsonString) => fromJsonString(jsonString));
      items.addAll(deserializedItems.where((item) => !_contains(item)));
      notifyListeners();
    }
  }

  Future<bool> _persist() async {
    final serializedList = items.map((item) => item.toJsonString()).toList();
    final preferences = await SharedPreferences.getInstance();
    return preferences.setStringList(storeKey, serializedList);
  }
}
