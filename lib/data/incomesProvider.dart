// import 'package:monies/data/models/incomeType.dart';
import 'package:monies/services/signInService.dart';
// import 'package:monies/utils/textsHelpers.dart';

import 'expensesProvider.dart';
import 'models/income.dart';
import 'extensions/withDate.dart';
import 'baseStorageProvider.dart';
// import 'extensions/withAmount.dart';

class IncomesProvider extends BaseStorageProvider<Income> {
  ExpensesProvider _expensesProvider;

  set expensesProvider(ExpensesProvider expensesProvider) {
    _expensesProvider = expensesProvider;
  }

  IncomesProvider({SignInService authService, bool databaseStorageEnabled = true})
      : super(
          storeKey: "Incomes",
          fromJsonString: Income.fromJsonString,
          fromJsonMap: Income.fromJsonMap,
          authService: authService,
          databaseStorageEnabled: databaseStorageEnabled,
        );

  @override
  List<Income> getAll() {
    return super.getAll().sortByDateAsc();
  }

  ///Retrieves incomes for given `month` and `year` and adds balance from previous month
  Iterable<Income> getForMonth(int month, int year) {
    final incomes = getAll().filterByDate(month, year);
    //adding this recursively causes stack overflow (it makes sense). It should be added to database and kept updated somehow.
    // List<Income> result = [BalanceIncome(month, year, this, _expensesProvider)];
    // result.addAll(incomes);
    // return result;
    return incomes;
  }
}

// class BalanceIncome extends Income {
//   double lastMonthBalance(IncomesProvider incomeProvider, ExpensesProvider expensesProvider) {
//     final lastMonthDate = date.subtract(Duration(days: 10));
//     final expensesSum = expensesProvider.getForMonth(lastMonthDate.month, lastMonthDate.year).sum();
//     final incomesSum = incomeProvider.getForMonth(lastMonthDate.month, lastMonthDate.year).sum();
//     return incomesSum - expensesSum;
//   }

//   Function calculateBalance;

//   BalanceIncome(int currentMonth, int currentYear, IncomesProvider incomeProvider, ExpensesProvider expensesProvider)
//       : super.fromValues("", "", DateTime(currentYear, currentMonth, 1), IncomeType.lastMonthBalance, "") {
//     title = IncomeType.lastMonthBalance.incomeTitle(date);
//     calculateBalance = () => { lastMonthBalance(incomeProvider, expensesProvider) };
//   }

//   @override
//   double get amount => calculateBalance == null ? 0 : calculateBalance();
// }
