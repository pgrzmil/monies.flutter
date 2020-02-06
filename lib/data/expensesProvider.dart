import 'package:monies/data/baseProvider.dart';
import 'models/expense.dart';

class ExpensesProvider extends BaseProvider<Expense> {
  ExpensesProvider() : super(storeKey: "Expenses", fromJsonString: Expense.fromJsonString);

  @override
  List<Expense> getAll() {
     items.sort((exp1, exp2) => exp1.date.compareTo(exp2.date));
     return super.getAll();
  }
}
