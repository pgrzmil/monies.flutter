import 'package:monies/data/models/modules.dart';
import 'package:monies/data/recurringExpensesProvider.dart';
import 'baseStorageProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseStorageProvider<Expense> {
  RecurringExpensesProvider _recurringExpensesProvider;
  ExpensesProvider() : super(storeKey: "Expenses", fromJsonString: Expense.fromJsonString);

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
}

extension ExpensesExtension on Iterable<Expense> {
  Iterable<Expense> filterByCategory(String categoryId) {
    return categoryId == null ? this : this.where((expense) => expense.categoryId == categoryId);
  }
}
