import 'package:monies/data/models/modules.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'baseStorageProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseStorageProvider<Expense> {
  RecurringExpensesProvider _recurringExpensesProvider;
  final String _recurringAddedKey = "RecurringAddMap";

  ///Collection of values indicating for what month recurring expenses has been already generated
  List<String> _recurringExpensesGeneratingMap;

  ExpensesProvider() : super(storeKey: "Expenses", fromJsonString: Expense.fromJsonString, fromJsonMap: Expense.fromJsonMap);

  set recurringExpensesProvider(RecurringExpensesProvider recurringExpensesProvider) {
    _recurringExpensesProvider = recurringExpensesProvider;
    notifyListeners();
  }

  @override
  List<Expense> getAll() {
    return super.getAll().sortByDate();
  }

  ///Retrieves `count` of the latest expenses for given `month` and `year`
  List<Expense> getLatest(int count, int month, int year) {
    final monthsExpenses = getForMonth(month, year);
    var skipCount = monthsExpenses.length > count ? monthsExpenses.length - count : 0;

    return monthsExpenses.skip(skipCount).toList();
  }

  ///Retrieves expenses for given `month` and `year`
  Iterable<Expense> getForMonth(int month, int year) {
    return getAll().filterByDate(month, year);
  }

//------- Recurring expenses handling ----------------

  ///Adds to expenses list recurring expenses instances for given `month` and `year`.
  updateWithRecurring(int month, int year) {
    if (_recurringExpensesProvider == null || _recurringExpensesGeneratingMap.contains(_recurringId(month, year))) return;

    var expenses = getAll().filterByDate(month, year);
    var rExpenses = _recurringExpensesProvider.expensesFor(month, year);
    addAll(rExpenses.where((ex) => !expenses.any((item) => ex.recurringExpenseId == item.recurringExpenseId)));
    _setRecurringAdded(month, year);
  }

  String _recurringId(int month, int year) => "$month/$year";

  _setRecurringAdded(int month, int year) {
    _recurringExpensesGeneratingMap.add(_recurringId(month, year));
    persist();
  }

  ///Restores all recurring expenses instances for given `month` and `year` in case they were removed.
  refreshRecurring(int month, int year) {
    if (_recurringExpensesProvider == null) return;

    _recurringExpensesGeneratingMap.remove(_recurringId(month, year));
    items.removeWhere((expense) => expense.date.month == month && expense.date.year == year && expense.recurringExpenseId != null);
    updateWithRecurring(month, year);
  }

//------- Persistence ----------------

  @override
  Future<bool> persist() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_recurringAddedKey, _recurringExpensesGeneratingMap);

    return super.persist();
  }

  @override
  load() async {
    await super.load();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _recurringExpensesGeneratingMap = preferences.getStringList(_recurringAddedKey) ?? List<String>();
  }
}

extension ExpensesExtension on Iterable<Expense> {
  Iterable<Expense> filterByCategory(String categoryId) {
    return categoryId == null ? this : this.where((expense) => expense.categoryId == categoryId);
  }
}
