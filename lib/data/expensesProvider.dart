import 'package:monies/data/baseProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseProvider<Expense> {
  ExpensesProvider() : super(storeKey: "Expenses", fromJsonString: Expense.fromJsonString);

  @override
  List<Expense> getAll() {
    sortByDate();
    return super.getAll();
  }

  void sortByDate() {
    items.sort((exp1, exp2) => exp1.date.compareTo(exp2.date));
  }

  List<Expense> getLatest(int count, int month, int year) {
    //First reverse because take method gets items from the beginning. Second one to keep original order of the items. 
    return getAll()
                  .reversed
                  .where((item) => item.date.month == month && item.date.year == year)
                  .take(count)
                  .toList()
                  .reversed
                  .toList();
  }
}
