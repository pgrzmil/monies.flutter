import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:monies/services/signInService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/baseModel.dart';

typedef T ItemJsonSerializator<T>(String jsonString);
typedef T ItemJsonMapSerializator<T>(Map<String, dynamic> jsonMap);

abstract class BaseStorageProvider<T extends BaseModel> extends ChangeNotifier {
  List<T> items = [];
  final String storeKey;
  bool isLoading = false;

  //Determines if web storage should be used
  bool _databaseStorageEnabled = true;
  //Used to ensure items are loaded only once after launch. Prevents infinite loop when list is empty
  bool _shouldReload = true; 
  
  SignInService _authService;

  ///Item's json deserializing method.
  ///
  ///There is no way to use item constructor or static method from generic type abstract
  ///class so creator function is passed as parameter to super constructor.
  final ItemJsonSerializator<T> fromJsonString;
  final ItemJsonMapSerializator<T> fromJsonMap;

  BaseStorageProvider({this.fromJsonMap, this.storeKey, this.fromJsonString, SignInService authService, bool databaseStorageEnabled = true}) {
    _databaseStorageEnabled = databaseStorageEnabled;
    _authService = authService;
  }

  List<T> getAll() {
    if (_shouldReload) {
      _shouldReload = false;
      load();
    }
    return items;
  }

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
      try {
        await Firestore.instance.collection(storeKey).document(item.id).setData(item.toJsonMap());
      } catch (e) {
        print("Adding $storeKey from database error $e ");
      }
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
      try {
        await Firestore.instance.collection(storeKey).document(item.id).updateData(item.toJsonMap());
      } catch (e) {
        print("Editing $storeKey from database error $e ");
      }
    }
  }

  Future remove(T item, {bool silent = false}) async {
    if (_isNotNull(item) && _contains(item)) {
      items.remove(item);
      if (!silent) {
        notifyListeners();
      }
      await removeFromDatabase(item);
      await persist();
    }
  }

  void removeFromDatabase(T item) async {
    if (_databaseStorageEnabled) {
      try {
        await Firestore.instance.collection(storeKey).document(item.id).delete();
      } catch (e) {
        print("Removing $storeKey from database error $e ");
      }
    }
  }

  Future clear() async {
    items.clear();
    notifyListeners();
    await persist();
  }

  bool _contains(T item) => items.any((e) => e.id == item.id);
  bool _isNotNull(Object item) => item != null;

  Future refresh() async {
    await load();
  }

  Future load() async {
    if (isLoading) return;

    isLoading = true;

    if (_databaseStorageEnabled) {
      await _loadFromDatabase();
    } else {
      final preferences = await SharedPreferences.getInstance();
      final serializedList = preferences.getStringList(storeKey);

      if (serializedList != null) {
        final deserializedItems = serializedList.map((jsonString) => fromJsonString(jsonString));
        items.addAll(deserializedItems.where((item) => !_contains(item)));
      }
    }

    isLoading = false;
    notifyListeners();
  }

  void _loadFromDatabase() async {
    if (!(await _authService.isLoggedIn)) return;

    try {
      print("load web $storeKey");

      final snapshot = await Firestore.instance.collection(storeKey).where("userId", isEqualTo: _authService.userId).getDocuments();
      items = (snapshot.documents.map((item) => fromJsonMap(item.data))).toList();      
    } catch (e) {
      print("Loading $storeKey from database error $e ");
    }
  }

  Future<bool> persist() async {
    final serializedList = items.map((item) => item.toJsonString()).toList();
    final preferences = await SharedPreferences.getInstance();

    return preferences.setStringList(storeKey, serializedList);
  }
}
