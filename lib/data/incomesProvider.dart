import 'package:monies/services/signInService.dart';

import 'models/income.dart';
import 'extensions/withDate.dart';
import 'baseStorageProvider.dart';

class IncomesProvider extends BaseStorageProvider<Income> {
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

  ///Retrieves incomes for given `month` and `year`
  Iterable<Income> getForMonth(int month, int year) {
    return getAll().filterByDate(month, year);
  }
}
