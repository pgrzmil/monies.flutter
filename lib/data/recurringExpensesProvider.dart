import 'package:jiffy/jiffy.dart';
import 'package:monies/data/models/recurringExpense.dart';
import 'baseStorageProvider.dart';
import 'models/expense.dart';

class RecurringExpensesProvider extends BaseStorageProvider<RecurringExpense> {
  RecurringExpensesProvider() : super(storeKey: "RecurringExpenses", fromJsonString: RecurringExpense.fromJsonString);

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
