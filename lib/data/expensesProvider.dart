import 'baseStorageProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseStorageProvider<Expense> {
  ExpensesProvider() : super(storeKey: "Expenses", fromJsonString: Expense.fromJsonString);

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
  
  Iterable<Expense> filterByDate(int month, int year) {
    return this.where((expense) => expense.date.month == month && expense.date.year == year);
  }

  List<Expense> sortByDate() {
    var sorted = this.toList();
    sorted.sort((exp1, exp2) => exp1.date.compareTo(exp2.date));
    return sorted;
  }

  double sum() {
    return fold(0, (value, expense) => value + expense.amount);
  }
}
