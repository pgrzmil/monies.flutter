import 'models/income.dart';
import 'extensions/withDate.dart';
import 'baseStorageProvider.dart';

class IncomesProvider extends BaseStorageProvider<Income> {
  IncomesProvider() : super(storeKey: "Incomes", fromJsonString: Income.fromJsonString, fromJsonMap: Income.fromJsonMap);

  @override
  List<Income> getAll() {
    return super.getAll().sortByDate();
  }

  ///Retrieves incomes for given `month` and `year`
  Iterable<Income> getForMonth(int month, int year) {
    return getAll().filterByDate(month, year);
  }
}
