import 'baseStorageProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseStorageProvider<Expense> {
  ExpensesProvider() : super(storeKey: "Expenses", fromJsonString: Expense.fromJsonString);

  @override
  List<Expense> getAll() {
    _sortByDate();
    return super.getAll();
  }

  void _sortByDate() {
    items.sort((exp1, exp2) => exp1.date.compareTo(exp2.date));
  }
 
  ///Retrieves `count` of the latest expenses for given `month` and `year` 
  List<Expense> getLatest(int count, int month, int year) {
    final monthsExpenses = getForMonth(month, year);
    var skipCount = monthsExpenses.length > count ? monthsExpenses.length - count : 0;

    return monthsExpenses.skip(skipCount).toList();
  }

  ///Retrieves expenses for given `month` and `year`
  Iterable<Expense> getForMonth(int month, int year) {
    return getAll().where((item) => item.date.month == month && item.date.year == year);
  }
}
