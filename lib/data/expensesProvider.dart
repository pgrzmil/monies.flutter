import 'package:monies/data/baseProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseProvider<Expense> {
  ExpensesProvider() : super(storeKey: "Expenses", fromJsonString: Expense.fromJsonString);
}
