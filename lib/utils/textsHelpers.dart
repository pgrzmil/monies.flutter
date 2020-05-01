import 'package:monies/data/models/incomeType.dart';

extension TextsExtension on IncomeType {
  String incomeTitle(DateTime currentDate) {
    var title = "";
    switch (this) {
      case IncomeType.lastMonthBalance:
        title = "Saldo z ${currentDate.lastMonthNameForIncomeTitle}";
        break;
      case IncomeType.invoice:
        title = "Fakturka z ${currentDate.lastMonthNameForIncomeTitle}";
        break;
      case IncomeType.salary:
        title = "Wypłata z ${currentDate.lastMonthNameForIncomeTitle}";
        break;
      default:
    }

    return title;
  }
}

extension TextExtension on DateTime {
  String get lastMonthNameForIncomeTitle {
    final monthNames = [
      "",
      "stycznia",
      "lutego",
      "marca",
      "kwietnia",
      "maja",
      "czerwca",
      "lipca",
      "sierpnia",
      "września",
      "października",
      "listopada",
      "grudnia"
    ];
    final nextMonth = month == 1 ? 12 : month - 1;
    return monthNames[nextMonth];
  }
}
