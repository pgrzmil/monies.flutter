import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/baseModel.dart';

typedef T ItemJsonSerializator<T>(String jsonString);

class BaseProvider<T extends BaseModel> extends ChangeNotifier {
  final List<T> items = [];
  final String storeKey;

  //In the super constructor is passed method for creating model object from json string.
  //There is no way to use item constructor or static method in generic type abstract class 
  //so creator function is passed as parameter.
  final ItemJsonSerializator<T> fromJsonString;

  BaseProvider({this.storeKey, this.fromJsonString});

  Future<List<T>> getAllAsync() async {
    await _load();
    return Future.value(items);
  }

  Future<T> getByAsync({String id}) async {
    await _load();
    return Future.value(items.firstWhere((x) => x.id == id, orElse: () => null));
  }

  List<T> getAll() => items;
  T getBy({String id}) => items.firstWhere((x) => x.id == id, orElse: () => null);

  add(T item) {
    if (_isNotNull(item) && !_contains(item)) {
      items.add(item);
      _persist();
      notifyListeners();
    }
  }

  edit(T item) {
    if (_isNotNull(item) && _contains(item)) {
      //item reference is passed to widgets hence edit method only needs to store and notify about changes
      _persist();
      notifyListeners();
    }
  }

  remove(T item) {
    if (_isNotNull(item) && _contains(item)) {
      items.remove(item);
      _persist();
      notifyListeners();
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
      items.addAll(deserializedItems);
    }
  }

  Future<bool> _persist() async {
    final serializedList = items.map((item) => item.toJsonString()).toList();
    final preferences = await SharedPreferences.getInstance();
    return preferences.setStringList(storeKey, serializedList);
  }
}
