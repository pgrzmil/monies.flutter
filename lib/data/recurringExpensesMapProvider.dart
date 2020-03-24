import 'package:monies/services/signInService.dart';
import 'models/recurringExpensesMapItem.dart';
import 'baseStorageProvider.dart';

class RecurringExpensesMapProvider extends BaseStorageProvider<RecurringExpensesMapItem> {
  RecurringExpensesMapProvider({SignInService authService, bool databaseStorageEnabled = true})
      : super(
          storeKey: "RecurringExpensesMap",
          fromJsonString: RecurringExpensesMapItem.fromJsonString,
          fromJsonMap: RecurringExpensesMapItem.fromJsonMap,
          authService: authService,
          databaseStorageEnabled: databaseStorageEnabled,
        );
}
