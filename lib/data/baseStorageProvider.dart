import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/baseModel.dart';

typedef T ItemJsonSerializator<T>(String jsonString);
typedef T ItemJsonMapSerializator<T>(Map<String, dynamic> jsonMap);

abstract class BaseStorageProvider<T extends BaseModel> extends ChangeNotifier {
  final List<T> items = [];
  final String storeKey;
  bool _databaseStorageEnabled = true;

  ///Item's json deserializing method.
  ///
  ///There is no way to use item constructor or static method from generic type abstract
  ///class so creator function is passed as parameter to super constructor.
  final ItemJsonSerializator<T> fromJsonString;
  final ItemJsonMapSerializator<T> fromJsonMap;

  BaseStorageProvider({this.fromJsonMap, this.storeKey, this.fromJsonString, bool databaseStorageEnabled = true}) {
    _databaseStorageEnabled = databaseStorageEnabled;
    load();
  }

  List<T> getAll() => items;

  T getBy({String id}) => items.firstWhere((x) => x.id == id, orElse: () => null);

  Future add(T item) async {
    if (_isNotNull(item) && !_contains(item)) {
      items.add(item);
      notifyListeners();
      await addToDatabase(item);
      await persist();
    }
  }

  void addToDatabase(T item) async {
    if (_databaseStorageEnabled) {
      await Firestore.instance.collection(storeKey).document(item.id).setData(item.toJsonMap());
    }
  }

  Future addAll(Iterable<T> array) async {
    if (_isNotNull(array)) {
      items.addAll(array.where((item) => !_contains(item)));
      notifyListeners();
      await addAllToDatabase(array);
      await persist();
    }
  }

  void addAllToDatabase(Iterable<T> array) async {
    if (_databaseStorageEnabled) {
      for (var item in array) {
        await addToDatabase(item);
      }
    }
  }

  Future edit(T item) async {
    if (_isNotNull(item) && _contains(item)) {
      //item reference is passed to widgets hence edit method only needs to store and notify about changes
      notifyListeners();
      await editInDatabase(item);
      await persist();
    }
  }

  void editInDatabase(T item) async {
    if (_databaseStorageEnabled) {
      await Firestore.instance.collection(storeKey).document(item.id).updateData(item.toJsonMap());
    }
  }

  Future remove(T item) async {
    if (_isNotNull(item) && _contains(item)) {
      items.remove(item);
      notifyListeners();
      await removeFromDatabase(item);
      await persist();
    }
  }

  void removeFromDatabase(T item) async {
    if (_databaseStorageEnabled) {
      await Firestore.instance.collection(storeKey).document(item.id).delete();
    }
  }

  Future clear() async {
    items.clear();
    notifyListeners();
    await persist();
  }

  bool _contains(T item) => items.any((e) => e.id == item.id);
  bool _isNotNull(Object item) => item != null;

// Persistence methods
  load() async {
    if (items.isNotEmpty) return;

    await loadFromDatabase();

    if (items.isEmpty) {
      final preferences = await SharedPreferences.getInstance();
      final serializedList = preferences.getStringList(storeKey);

      if (serializedList != null) {
        final deserializedItems = serializedList.map((jsonString) => fromJsonString(jsonString));
        items.addAll(deserializedItems.where((item) => !_contains(item)));
        notifyListeners();
      }
      notifyListeners();
    }
  }

  void loadFromDatabase() async {
    if (_databaseStorageEnabled) {
      try {
        final preferences = await SharedPreferences.getInstance();
        final userId = preferences.getString("userId");
        final snapshot = await Firestore.instance.collection(storeKey).where("userId", isEqualTo: userId).getDocuments();
        items.addAll(snapshot.documents.map((item) => fromJsonMap(item.data)));
      } catch (e) {
        print("Insufficient permissions on load");
      }
    }
  }

  Future<bool> persist() async {
    final serializedList = items.map((item) => item.toJsonString()).toList();
    final preferences = await SharedPreferences.getInstance();

    return preferences.setStringList(storeKey, serializedList);
  }
}
