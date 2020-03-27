import 'package:monies/data/models/modules.dart';
import 'package:monies/data/models/recurringExpensesMapItem.dart';
import 'package:monies/data/recurringExpensesMapProvider.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'package:monies/services/signInService.dart';
import 'baseStorageProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseStorageProvider<Expense> {
  RecurringExpensesProvider _recurringExpensesProvider;
  RecurringExpensesMapProvider _recurringExpensesMapProvider;

  ExpensesProvider({SignInService authService, bool databaseStorageEnabled = true})
      : super(
          storeKey: "Expenses",
          fromJsonString: Expense.fromJsonString,
          fromJsonMap: Expense.fromJsonMap,
          authService: authService,
          databaseStorageEnabled: databaseStorageEnabled,
        );

  set recurringExpensesProvider(RecurringExpensesProvider recurringExpensesProvider) {
    _recurringExpensesProvider = recurringExpensesProvider;
  }

  set recurringExpensesMapProvider(RecurringExpensesMapProvider recurringExpensesMapProvider) {
    _recurringExpensesMapProvider = recurringExpensesMapProvider;
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
  updateWithRecurring(int month, int year, String userId) async {
    final mapItemTitle = _recurringId(month, year);
    if (_recurringExpensesProvider == null || _recurringExpensesMapProvider.getAll().any((x) => x.title == mapItemTitle)) return;

    final currentExpenses = getAll().filterByDate(month, year);
    final generatedRecurringExpenses = _recurringExpensesProvider.expensesFor(month, year, userId);
    final expensesToAdd = generatedRecurringExpenses.where((ex) => !currentExpenses.any((item) => ex.recurringExpenseId == item.recurringExpenseId));
    if (expensesToAdd.isNotEmpty) {
      await addAll(expensesToAdd);
      _setRecurringAdded(month, year, userId);
      notifyListeners();
    }
  }

  String _recurringId(int month, int year) => "$month/$year";

  _setRecurringAdded(int month, int year, String userId) {
    final recurringMapItem = RecurringExpensesMapItem.fromValues(_recurringId(month, year), userId);
    _recurringExpensesMapProvider.add(recurringMapItem);
    persist();
  }

  ///Restores all recurring expenses instances for given `month` and `year` in case they were removed.
  refreshRecurring(int month, int year, String userId) {
    if (_recurringExpensesProvider == null) return;

    final mapItemToRemove = _recurringExpensesMapProvider.getAll().firstWhere((x) => x.title == _recurringId(month, year));
    _recurringExpensesMapProvider.remove(mapItemToRemove);

    final expensesToRemove =
        items.where((expense) => expense.date.month == month && expense.date.year == year && expense.recurringExpenseId != null).toList();
    for (var item in expensesToRemove) {
      remove(item);
    }

    updateWithRecurring(month, year, userId);
  }

  @override
  load() {
    super.load();
    _recurringExpensesProvider?.load();
    _recurringExpensesMapProvider?.load();
  }
}

extension ExpensesExtension on Iterable<Expense> {
  Iterable<Expense> filterByCategory(String categoryId) {
    return categoryId == null ? this : this.where((expense) => expense.categoryId == categoryId);
  }
}
