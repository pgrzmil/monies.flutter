import 'package:jiffy/jiffy.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'baseStorageProvider.dart';
import 'models/expense.dart';

class RecurringExpensesProvider extends BaseStorageProvider<RecurringExpense> {
  RecurringExpensesProvider() : super(storeKey: "RecurringExpenses", fromJsonString: RecurringExpense.fromJsonString);

  @override
  List<RecurringExpense> getAll() {
    return super.getAll().sortByDate();
  }

  ///Returns expenses for given `month` and `year` crated from recurring expenses
  Iterable<Expense> expensesFor(int month, int year) {
    final endOfTheMonth = Jiffy(DateTime(year, month)).endOf("M");

    return getAll().where((item) => item.startDate.isBefore(endOfTheMonth)).map((item) {
      final day = item.startDate.day > endOfTheMonth.day ? endOfTheMonth.day : item.startDate.day;

      return Expense.fromValues(
        item.title,
        item.location,
        item.amount,
        DateTime(year, month, day),
        item.categoryId,
        recurringExpenseId: item.id,
      );
    });
  }
}

extension _RecurringExpensesProviderExtensions on Iterable<RecurringExpense> {
  List<RecurringExpense> sortByDate() {
    var sorted = this.toList();
    sorted.sort((exp1, exp2) => exp1.startDate.compareTo(exp2.startDate));
    return sorted;
  }
}
